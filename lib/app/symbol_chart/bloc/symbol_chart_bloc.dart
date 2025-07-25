import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_event.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_state.dart';
import 'package:piapiri_v2/app/symbol_chart/repository/symbol_chart_repository.dart';
import 'package:piapiri_v2/app/symbol_chart/utils/symbol_chart_utils.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/chart_model.dart';
import 'package:piapiri_v2/core/model/chart_performance_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class SymbolChartBloc extends PBloc<SymbolChartState> {
  final SymbolChartRepository _symbolChartRepository;

  SymbolChartBloc({
    required SymbolChartRepository symbolChartRepository,
  })  : _symbolChartRepository = symbolChartRepository,
        super(
          initialState: SymbolChartState(
            minimumDate: DateTime.now(),
          ),
        ) {
    on<GetDataEvent>(_onGetData);
    on<GetPerformanceEvent>(_onGetPerformance);
    on<AddPerformanceEvent>(_onAddPerformance);
    on<RemovePerformanceEvent>(_onRemovePerformance);
    on<GetDataByDateRangeEvent>(_onGetDataByDateRange);
    on<SetChartTypeEvent>(_onSetChartType);
    on<SymbolChangeChartCurrencyEvent>(_onChangeChartCurrency);
  }
  FutureOr<void> _onGetData(
    GetDataEvent event,
    Emitter<SymbolChartState> emit,
  ) async {
    if (event.symbolName == 'A') {
      emit(
        state.copyWith(
          type: PageState.failed,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ChartType chartType = await _symbolChartRepository.getChartType();
    ApiResponse response = await _symbolChartRepository.symbolDetailBar(
      event.symbolName,
      event.filter ?? state.selectedFilter,
      derivedUrl: getIt<MatriksBloc>().state.endpoints!.rest!.derivedBar!.url ?? '',
      barUrl: getIt<MatriksBloc>().state.endpoints!.rest!.bar!.url ?? '',
      currencyEnum: state.chartCurrency,
    );

    if (response.success && response.data.isNotEmpty) {
      List<SymbolChartModel> data = response.data.map<SymbolChartModel>((e) => SymbolChartModel.fromJson(e)).toList();
      List<ChartData> chartData = createChartData(data);

      emit(
        state.copyWith(
          type: PageState.success,
          data: data,
          chartData: chartData,
          minimumDate: SymbolChartUtils().calculateMinimumXAxisForSFCartesianChart(
            event.filter ?? state.selectedFilter,
          ),
          selectedFilter: event.filter,
          chartType: chartType,
        ),
      );

      event.callback?.call(data);
      return;
    }
    emit(
      state.copyWith(
        type: PageState.failed,
      ),
    );
  }

  // Verilen Sembollerin performans datalarini cekerek state  yazar
  FutureOr<void> _onGetPerformance(
    GetPerformanceEvent event,
    Emitter<SymbolChartState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
        performanceData: [],
      ),
    );

    List<dynamic> requestList = [];

    for (ChartPerformanceModel element in event.chartPerformanceModels) {
      if (element.symbolType == SymbolTypes.foreign) {
        (DateTime, DateTime) dates = _getPerformanceDate(event.performanceFilter);
        requestList.add(
          _symbolChartRepository.getUsChartData(
            symbols: element.symbolName,
            timeframe: event.performanceFilter.performancePeriodUs!,
            currency: CurrencyEnum.dollar.shortName.toUpperCase(),
            start: dates.$1.toIso8601String(),
            end: dates.$2.toIso8601String(),
          ),
        );
      } else if (element.symbolType == SymbolTypes.fund) {
        (DateTime, DateTime) dates = _getPerformanceDate(event.performanceFilter);
        requestList.add(
          _symbolChartRepository.getFundChartData(
            symbol: element.symbolName,
            period: event.performanceFilter.performancePeriodFund ?? '1D',
            start: dates.$1.toIso8601String(),
            end: dates.$2.toIso8601String(),
          ),
        );
      } else {
        (DateTime, DateTime) dates = _getPerformanceDate(event.performanceFilter);
        requestList.add(
          _symbolChartRepository.symbolDetailBar(
            element.symbolName,
            event.performanceFilter,
            dates: MapEntry<String, String>(dates.$1.formatToJson(), dates.$2.formatToJson()),
            derivedUrl: getIt<MatriksBloc>().state.endpoints!.rest!.derivedBar!.url ?? '',
            barUrl: getIt<MatriksBloc>().state.endpoints!.rest!.bar!.url ?? '',
            currencyEnum: state.chartCurrency,
            isPerformance: true,
          ),
        );
      }
    }

    List<ApiResponse> responses = await Future.wait([...requestList]);
    List<ChartPerformanceModel> performanceData = [];
    List<ChartPerformanceData> data = [];

    for (int i = 0; i < responses.length; i++) {
      if (responses[i].success) {
        if (event.chartPerformanceModels[i].symbolType == SymbolTypes.foreign) {
          final rawData = responses[i].data['barList'] as List<dynamic>;
          data = convertToDailyPerformanceUs(
            rawData.cast<Map<String, dynamic>>(),
          );
        } else if (event.chartPerformanceModels[i].symbolType == SymbolTypes.fund) {
          final rawData = responses[i].data['fundPriceGraphList'] as List<dynamic>;
          data = convertToDailyPerformanceFund(
            rawData.cast<Map<String, dynamic>>(),
          );
        } else {
          final rawData = responses[i].data as List<dynamic>;
          data = convert240MinToDailyPerformance(rawData.cast<Map<String, dynamic>>());
        }
        bool performanceDataIsEmpty = false;

        if (responses[i].data == null) {
          performanceDataIsEmpty = true;
        } else if (event.chartPerformanceModels[i].symbolType == SymbolTypes.foreign &&
            (responses[i].data['barList'] as List).isEmpty) {
          performanceDataIsEmpty = true;
        } else if (event.chartPerformanceModels[i].symbolType == SymbolTypes.fund &&
            (responses[i].data['fundPriceGraphList'] == null ||
                (responses[i].data['fundPriceGraphList'] as List).isEmpty)) {
          performanceDataIsEmpty = true;
        } else if (responses[i].data.isEmpty) {
          performanceDataIsEmpty = true;
        }

        double? close;
        double? open;

        if (!performanceDataIsEmpty) {
          if (event.chartPerformanceModels[i].symbolType == SymbolTypes.foreign) {
            close = double.tryParse(responses[i].data['barList'].last['close'].toStringAsFixed(2));
            open = double.tryParse(responses[i].data['barList'].first['open'].toStringAsFixed(2));
          } else if (event.chartPerformanceModels[i].symbolType == SymbolTypes.fund) {
            close = double.tryParse(responses[i].data['fundPriceGraphList'].last['price'].toStringAsFixed(6));
            open = double.tryParse(responses[i].data['fundPriceGraphList'].first['price'].toStringAsFixed(6));
          } else {
            close = double.tryParse(responses[i].data.last['close'].toStringAsFixed(2));
            open = double.tryParse(responses[i].data.first['open'].toStringAsFixed(2));
          }
        }

        double generalPerformance = close == null || open == null ? 0 : ((close - open) / open) * 100;
        performanceData.add(
          ChartPerformanceModel(
            symbolName: event.chartPerformanceModels[i].symbolName,
            symbolType: event.chartPerformanceModels[i].symbolType,
            subType: event.chartPerformanceModels[i].subType,
            underlyingName: event.chartPerformanceModels[i].underlyingName,
            description: event.chartPerformanceModels[i].description,
            data: data,
            performance: generalPerformance,
          ),
        );
      }
    }

    emit(
      state.copyWith(
        type: PageState.success,
        performanceData: performanceData,
        selectedPerformanceFilter: event.performanceFilter,
      ),
    );
  }

  // Karsilastirmaya yeni sembol eklenecegi zaman calisir
  FutureOr<void> _onAddPerformance(
    AddPerformanceEvent event,
    Emitter<SymbolChartState> emit,
  ) async {
    emit(
      state.copyWith(type: PageState.loading),
    );
    late ApiResponse response;

    if (event.chartPerformance.symbolType == SymbolTypes.foreign) {
      (DateTime, DateTime) dates = _getPerformanceDate(state.selectedPerformanceFilter);
      response = await _symbolChartRepository.getUsChartData(
        symbols: event.chartPerformance.symbolName,
        timeframe: state.selectedFilter.usPeriod!,
        currency: CurrencyEnum.dollar.shortName.toUpperCase(),
        start: dates.$1.toIso8601String(),
        end: dates.$2.toIso8601String(),
      );
    } else if (event.chartPerformance.symbolType == SymbolTypes.fund) {
      (DateTime, DateTime) dates = _getPerformanceDate(state.selectedPerformanceFilter);
      response = await _symbolChartRepository.getFundChartData(
        symbol: event.chartPerformance.symbolName,
        period: state.selectedFilter.fundPeriod!,
        start: dates.$1.toIso8601String(),
        end: dates.$2.toIso8601String(),
      );
    } else {
      (DateTime, DateTime) dates = _getPerformanceDate(state.selectedPerformanceFilter);
      response = await _symbolChartRepository.symbolDetailBar(
        event.chartPerformance.symbolName,
        state.selectedFilter,
        dates: MapEntry<String, String>(dates.$1.toIso8601String(), dates.$2.toIso8601String()),
        derivedUrl: getIt<MatriksBloc>().state.endpoints!.rest!.derivedBar!.url ?? '',
        barUrl: getIt<MatriksBloc>().state.endpoints!.rest!.bar!.url ?? '',
        currencyEnum: state.chartCurrency,
      );
    }

    if (response.success) {
      bool performanceDataIsEmpty = false;

      if (response.data == null) {
        performanceDataIsEmpty = true;
      } else if (event.chartPerformance.symbolType == SymbolTypes.foreign &&
          (response.data['barList'] as List).isEmpty) {
        performanceDataIsEmpty = true;
      } else if (event.chartPerformance.symbolType == SymbolTypes.fund &&
          (response.data['fundPriceGraphList'] == null || (response.data['fundPriceGraphList'] as List).isEmpty)) {
        performanceDataIsEmpty = true;
      } else if (response.data.isEmpty) {
        performanceDataIsEmpty = true;
      }

      double? close;
      double? open;

      if (!performanceDataIsEmpty) {
        if (event.chartPerformance.symbolType == SymbolTypes.foreign) {
          close = double.tryParse(response.data['barList'].last['close'].toStringAsFixed(2));
          open = double.tryParse(response.data['barList'].first['open'].toStringAsFixed(2));
        } else if (event.chartPerformance.symbolType == SymbolTypes.fund) {
          close = double.tryParse(response.data['fundPriceGraphList'].last['price'].toStringAsFixed(6));
          open = double.tryParse(response.data['fundPriceGraphList'].first['price'].toStringAsFixed(6));
        } else {
          close = double.tryParse(response.data.last['close'].toStringAsFixed(2));
          open = double.tryParse(response.data.first['open'].toStringAsFixed(2));
        }
      }

      double generalPerformance = close == null || open == null ? 0 : ((close - open) / open) * 100;

      List<ChartPerformanceData> data = [];

      if (event.chartPerformance.symbolType == SymbolTypes.foreign) {
        data = List<ChartPerformanceData>.from(response.data['barList'].map((e) {
          double performance =
              ((double.parse(e['close'].toStringAsFixed(2)) - double.parse(e['open'].toStringAsFixed(2))) /
                      double.parse(e['open'].toStringAsFixed(2))) *
                  100;
          DateTime time = DateTime.parse(e['timeUtc']);
          return ChartPerformanceData(
            DateTime(time.year, time.month, time.day),
            performance,
          );
        }));
      } else if (event.chartPerformance.symbolType == SymbolTypes.fund) {
        for (Map element in response.data['fundPriceGraphList']) {
          if (element['performance'] != null) {
            double performance = double.parse(element['performance'].toStringAsFixed(6)) * 100;
            DateTime time = DateTime.parse(element['date']);
            data.add(
              ChartPerformanceData(
                DateTime(time.year, time.month, time.day),
                performance,
              ),
            );
          }
        }
      } else {
        data = List<ChartPerformanceData>.from(response.data.map((e) {
          double performance =
              ((double.parse(e['close'].toStringAsFixed(2)) - double.parse(e['open'].toStringAsFixed(2))) /
                      double.parse(e['open'].toStringAsFixed(2))) *
                  100;
          DateTime time = DateTime.fromMillisecondsSinceEpoch(e['time']);
          return ChartPerformanceData(
            DateTime(time.year, time.month, time.day),
            performance,
          );
        }));
      }

      emit(
        state.copyWith(
          type: PageState.success,
          performanceData: [
            ...state.performanceData,
            ChartPerformanceModel(
              symbolName: event.chartPerformance.symbolName,
              underlyingName: event.chartPerformance.underlyingName,
              subType: event.chartPerformance.subType,
              symbolType: event.chartPerformance.symbolType,
              description: event.chartPerformance.description,
              data: data,
              performance: generalPerformance,
            )
          ],
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: L10n.tr(response.error?.message ?? ''),
            errorCode: '01GACC02',
          ),
        ),
      );
    }
  }

  // Karsilastirmadan sembol cikarilacagi zaman calisir
  FutureOr<void> _onRemovePerformance(
    RemovePerformanceEvent event,
    Emitter<SymbolChartState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.success,
        performanceData: state.performanceData.where((element) => element.symbolName != event.symbolName).toList(),
      ),
    );
  }

  FutureOr<void> _onGetDataByDateRange(
    GetDataByDateRangeEvent event,
    Emitter<SymbolChartState> emit,
  ) async {
    if (event.symbolName != 'A') {
      emit(
        state.copyWith(
          type: PageState.loading,
        ),
      );

      ApiResponse response = await _symbolChartRepository.symbolDetailBarByDateRange(
        event.symbolName,
        startDate: event.startDate,
        endDate: event.endDate,
        barUrl: getIt<MatriksBloc>().state.endpoints!.rest!.bar!.url ?? '',
      );

      if (response.success) {
        List<SymbolChartModel>? data =
            response.data.map<SymbolChartModel>((e) => SymbolChartModel.fromJson(e)).toList();

        emit(
          state.copyWith(
            type: PageState.success,
            data: data,
          ),
        );

        event.callback?.call(data ?? []);
      } else {
        emit(
          state.copyWith(
            type: PageState.failed,
          ),
        );
      }
    }
  }

  List<ChartData> createChartData(
    List<SymbolChartModel> data,
  ) {
    List<ChartData> chart = data
        .map<ChartData>(
          (element) => ChartData(
            element.date,
            element.open,
            element.high,
            element.low,
            element.close,
          ),
        )
        .toList();

    return chart;
  }

  FutureOr<void> _onSetChartType(
    SetChartTypeEvent event,
    Emitter<SymbolChartState> emit,
  ) {
    _symbolChartRepository.writeChartType(
      chartTypeName: event.chartType.value,
    );

    emit(
      state.copyWith(
        chartType: event.chartType,
      ),
    );
  }

  FutureOr<void> _onChangeChartCurrency(
    SymbolChangeChartCurrencyEvent event,
    Emitter<SymbolChartState> emit,
  ) {
    emit(
      state.copyWith(
        chartCurrency: state.chartCurrency == CurrencyEnum.turkishLira ? CurrencyEnum.dollar : CurrencyEnum.turkishLira,
      ),
    );
  }

  DateTime _subtractMonths(DateTime date, int months) {
    int year = date.year;
    int month = date.month - months;

    // Yılı ayarlayalım (örneğin: -2. ay gibi durumlar için)
    while (month <= 0) {
      month += 12;
      year -= 1;
    }

    // Gün uyuşmazlığına karşı: önceki ayın son gününü bul
    int day = date.day;
    int lastDayOfMonth = DateTime(year, month + 1, 0).day;

    if (day > lastDayOfMonth) {
      day = lastDayOfMonth;
    }

    return DateTime(
      year,
      month,
      day,
      date.hour,
      date.minute,
      date.second,
      date.millisecond,
      date.microsecond,
    );
  }

  DateTime _subtractYears(DateTime date, int years) {
    int year = date.year - years;
    int month = date.month;
    int day = date.day;

    // Yeni yıl ve ayın son gününü bul
    int lastDayOfMonth = DateTime(year, month + 1, 0).day;

    if (day > lastDayOfMonth) {
      day = lastDayOfMonth;
    }

    return DateTime(
      year,
      month,
      day,
      date.hour,
      date.minute,
      date.second,
      date.millisecond,
      date.microsecond,
    );
  }

  (DateTime, DateTime) _getPerformanceDate(ChartFilter filter) {
    DateTime now = DateTime.now();
    DateTime startDate = DateTime(now.year, now.month, now.day);
    DateTime endDate = DateTime(now.year, now.month, now.day);
    if (filter == ChartFilter.oneWeek) {
      startDate = startDate.subtract(const Duration(days: 7));
    } else if (filter == ChartFilter.oneMonth) {
      startDate = _subtractMonths(startDate, 1);
    } else if (filter == ChartFilter.sixMonth) {
      startDate = _subtractMonths(startDate, 6);
    } else if (filter == ChartFilter.oneYear) {
      startDate = _subtractYears(startDate, 1);
    } else if (filter == ChartFilter.fiveYear) {
      startDate = _subtractYears(startDate, 5);
    }

    return (startDate, endDate);
  }

  List<ChartPerformanceData> convertToDailyPerformanceUs(List<Map<String, dynamic>> rawBars) {
    List<ChartPerformanceData> performanceData = [];
    rawBars.sort((a, b) => a['timeUtc'].compareTo(b['timeUtc']));

    double? open;
    double? close;

    for (Map<String, dynamic> bar in rawBars) {
      DateTime time = DateTime.parse(bar['timeUtc']);
      if (open != null) {
        open = open;
      } else {
        double numb = double.parse(bar['open'].toString());
        if (numb == 0) continue;
        open = numb;
      }
      close = double.parse(bar['close'].toString());
      double performance = double.parse((((close - open) / open) * 100).toStringAsFixed(2));
      performanceData.add(
        ChartPerformanceData(
          DateTime(time.year, time.month, time.day),
          performance,
        ),
      );
    }
    return performanceData;
  }

  List<ChartPerformanceData> convertToDailyPerformanceFund(List<Map<String, dynamic>> rawBars) {
    List<ChartPerformanceData> performanceData = [];
    rawBars.sort((a, b) => a['date'].compareTo(b['date']));
    double? open;
    double? close;
    // performance değeri null geldiği için price üzerinden hesaplıyoruz.
    // başlangıç performance değerini hesaplayamadığımız için 0 veriyoruz.
    for (Map<String, dynamic> bar in rawBars) {
      double performance;
      if (open != null) {
        open = open;
        close = double.parse(bar['price'].toString());
        performance = double.parse((((close - open) / open) * 100).toStringAsFixed(2));
      } else {
        double numb = double.parse(bar['price'].toString());
        if (numb == 0) continue;
        open = numb;
        performance = 0;
      }
      DateTime time = DateTime.parse(bar['date']);
      performanceData.add(
        ChartPerformanceData(
          DateTime(time.year, time.month, time.day),
          performance,
        ),
      );
    }
    return performanceData;
  }

  List<ChartPerformanceData> convert240MinToDailyPerformance(List<Map<String, dynamic>> rawBars) {
    // Veriyi parse edip tarih bazlı grupla
    Map<String, List<Map<String, dynamic>>> grouped = {};

    for (Map<String, dynamic> bar in rawBars) {
      final DateTime time = DateTime.fromMillisecondsSinceEpoch(bar['time']);
      final String dateKey =
          '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}';

      grouped.putIfAbsent(dateKey, () => []).add(bar);
    }

    List<ChartPerformanceData> performanceData = [];

    double? open;
    double? close;

    grouped.forEach((dateStr, bars) {
      bars.sort((a, b) => a['time'].compareTo(b['time']));

      if (open != null) {
        open = open;
      } else {
        double numb = double.parse(bars.first['open'].toString());
        if (numb == 0) return;
        open = numb;
      }
      close = double.parse(bars.last['close'].toString());
      double performance = double.parse((((close! - open!) / open!) * 100).toStringAsFixed(2));
      final dateParts = dateStr.split('-');
      final date = DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
      );

      performanceData.add(
        ChartPerformanceData(date, performance),
      );
    });
    return performanceData;
  }
}
