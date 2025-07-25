import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_state.dart';
import 'package:piapiri_v2/app/us_equity/repository/us_equity_repository.dart';
import 'package:piapiri_v2/app/us_symbol_detail/model/dividend_model.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/bloc/time/time_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/chart_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/latest_trade_mixed_model.dart';
import 'package:piapiri_v2/core/model/us_symbol_model.dart';

class UsEquityBloc extends PBloc<UsEquityState> {
  final UsEquityRepository _usEquityRepository;

  UsEquityBloc({
    required UsEquityRepository usEquityRepository,
  })  : _usEquityRepository = usEquityRepository,
        super(initialState: const UsEquityState()) {
    on<GetLosersGainersEvent>(_onGetLosersGainers);
    on<GetVolumesEvent>(_onGetVolumes);
    on<GetPopulersEvent>(_onGetPopulers);
    on<UpdateUsSymbolEvent>(_onUpdateUsSymbol);
    on<SubscribeSymbolEvent>(_onSubscribeSymbol);
    on<UnsubscribeSymbolEvent>(_onUnSubscribeSymbol);
    on<GetHistoricalBarsDataEvent>(_onGetHistoricalBarsData);
    on<StopConnectionEvent>(_onStopSubscription);
    on<GetLatestTradeMixedEvent>(_onGetLatestTradeMixed);
    on<UpdateTradeEvent>(_onUpdateTradeSymbol);
    on<UpdateDailyBarEvent>(_onUpdateDailyBar);
    on<GetDividendWeeklyEvent>(_onGetDividendWeekly);
    on<GetDividendYearlyEvent>(_onGetDividendYearly);
    on<GetDividendTwoYearEvent>(_onGetDividendTwoYear);
    on<GetUsIncomingDividends>(_onGetUsIncomingDividends);
    on<SetUsChartCurrentType>(_onSetUsChartCurrentType);
    on<SetUsChartType>(_onSetUsChartType);
  }

  FutureOr<void> _onGetLosersGainers(
    GetLosersGainersEvent event,
    Emitter<UsEquityState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ApiResponse response = await _usEquityRepository.getLosersGainers(number: event.number);
    if (response.success) {
      List<LoserGainerModel> losers =
          response.data['losersList'].map<LoserGainerModel>((json) => LoserGainerModel.fromJson(json)).toList();
      List<LoserGainerModel> gainers =
          response.data['gainersList'].map<LoserGainerModel>((json) => LoserGainerModel.fromJson(json)).toList();
      emit(
        state.copyWith(
          type: PageState.success,
          losers: losers,
          gainers: gainers,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: 'US01',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetVolumes(
    GetVolumesEvent event,
    Emitter<UsEquityState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ApiResponse response = await _usEquityRepository.getVolumes(number: event.number);
    if (response.success) {
      List<USStockModel> volumes =
          response.data['volumeList'].map<USStockModel>((json) => USStockModel.fromJson(json)).toList();
      emit(
        state.copyWith(
          type: PageState.success,
          volumes: volumes,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: 'US02',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetPopulers(
    GetPopulersEvent event,
    Emitter<UsEquityState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ApiResponse response = await _usEquityRepository.getPopulers(number: event.number);
    if (response.success) {
      List<USStockModel> populers =
          response.data['tradeList'].map<USStockModel>((json) => USStockModel.fromJson(json)).toList();
      emit(
        state.copyWith(
          type: PageState.success,
          populers: populers,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: 'US03',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetHistoricalBarsData(
    GetHistoricalBarsDataEvent event,
    Emitter<UsEquityState> emit,
  ) async {
    ChartFilter chartFilter = event.chartFilter ?? state.chartFilter;

    TimeBloc bloc = getIt<TimeBloc>();
    String start = DateTime.fromMicrosecondsSinceEpoch(
      bloc.state.mxTime?.timestamp != null
          ? bloc.state.mxTime!.timestamp.toInt()
          : DateTime.now().add(const Duration(hours: 3)).microsecondsSinceEpoch,
    ).subtract(chartFilter.duration).toUtc().toIso8601String();
    String end = DateTime.fromMicrosecondsSinceEpoch(
      getIt<TimeBloc>().state.mxTime?.timestamp != null
          ? getIt<TimeBloc>().state.mxTime!.timestamp.toInt()
          : DateTime.now().add(const Duration(hours: 3)).microsecondsSinceEpoch,
    ).subtract(const Duration(minutes: 15)).toUtc().toIso8601String();
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ApiResponse response = await _usEquityRepository.getHistoricalBarsData(
      symbols: event.symbols,
      start: start,
      end: end,
      timeframe: chartFilter.usPeriod!,
      currency: state.currencyType == CurrencyEnum.turkishLira ? 'TRY' : 'USD',
    );
    if (response.success) {
      List<CurrentDailyBar> graphData =
          response.data['barList'].map<CurrentDailyBar>((json) => CurrentDailyBar.fromJson(json)).toList();
      emit(
        state.copyWith(
          type: PageState.success,
          chartFilter: chartFilter,
          graphData: graphData,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          chartFilter: chartFilter,
          graphData: [],
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: 'US04',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetLatestTradeMixed(
    GetLatestTradeMixedEvent event,
    Emitter<UsEquityState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
        latestTradeMixed: event.symbols != state.latestTradeMixed?.symbol ? LatestTradeMixedModel() : null,
      ),
    );
    ApiResponse response = await _usEquityRepository.getLatestTradeMixed(
      symbols: event.symbols,
    );
    if (response.success) {
      LatestTradeMixedModel latestTradeMixed = LatestTradeMixedModel();
      if (response.data.isNotEmpty) {
        latestTradeMixed = LatestTradeMixedModel.fromJson(
          response.data,
        );
      } else {
        latestTradeMixed = LatestTradeMixedModel();
      }

      event.callback?.call(latestTradeMixed);
      emit(
        state.copyWith(
          type: PageState.success,
          latestTradeMixed: latestTradeMixed,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: 'US05',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onUpdateTradeSymbol(
    UpdateTradeEvent event,
    Emitter<UsEquityState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.updating,
      ),
    );

    Trade updatedSymbol = Trade.fromJson(event.data);

    int symbolIndex = state.watchingItems.indexWhere(
      (element) => element.asset?.symbol == updatedSymbol.symbol,
    );

    if (symbolIndex > -1) {
      List<USSymbolModel> symbols = List.from(state.watchingItems);
      symbols[symbolIndex] = symbols[symbolIndex].copyWith(
        trade: updatedSymbol,
      );
      emit(
        state.copyWith(
          watchingItems: symbols,
          type: PageState.success,
        ),
      );
    }
  }

  FutureOr<void> _onUpdateDailyBar(
    UpdateDailyBarEvent event,
    Emitter<UsEquityState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.updating,
      ),
    );
    CurrentDailyBar updatedSymbol = CurrentDailyBar.fromJson(event.data);
    int symbolIndex = state.watchingItems.indexWhere(
      (element) => element.asset?.symbol == updatedSymbol.symbol,
    );
    if (symbolIndex > -1) {
      List<USSymbolModel> symbols = List.from(state.watchingItems);
      symbols[symbolIndex] = symbols[symbolIndex].copyWith(
        currentDailyBar: updatedSymbol,
      );
      emit(
        state.copyWith(
          watchingItems: symbols,
          type: PageState.success,
        ),
      );
    }
  }

  FutureOr<void> _onUpdateUsSymbol(
    UpdateUsSymbolEvent event,
    Emitter<UsEquityState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.updating,
      ),
    );

    USSymbolModel symbol = USSymbolModel.fromJson(event.data);
    if (symbol.quote != null) {
      symbol.quote!.decimalCount =
          (symbol.trade!.price ?? 0) > 1 ? 2 : MoneyUtils().countDecimalPlaces(symbol.trade!.price ?? 0);
    }

    int symbolIndex = state.watchingItems.indexWhere((element) => element.asset?.name == symbol.asset?.name);

    if (symbolIndex > -1) {
      List<USSymbolModel> symbols = List.from(state.watchingItems);
      symbols[symbolIndex] = symbol;
      emit(
        state.copyWith(
          watchingItems: symbols,
          updatedSymbol: symbol,
          type: PageState.success,
        ),
      );
    } else {
      emit(
        state.copyWith(
          watchingItems: [...state.watchingItems, symbol],
          updatedSymbol: symbol,
          type: PageState.success,
        ),
      );
    }
  }

  FutureOr<void> _onSubscribeSymbol(
    SubscribeSymbolEvent event,
    Emitter<UsEquityState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.updating,
      ),
    );
    await _usEquityRepository.subscribeSymbol(event.symbolName);
    emit(
      state.copyWith(
        type: PageState.updated,
      ),
    );
  }

  FutureOr<void> _onUnSubscribeSymbol(
    UnsubscribeSymbolEvent event,
    Emitter<UsEquityState> emit,
  ) {
    emit(
      state.copyWith(
        type: PageState.updating,
      ),
    );
    _usEquityRepository.unsubscribeSymbol(event.symbolName);
    emit(
      state.copyWith(
        type: PageState.success,
      ),
    );
  }

  FutureOr<void> _onStopSubscription(
    StopConnectionEvent event,
    Emitter<UsEquityState> emit,
  ) {
    emit(
      state.copyWith(
        type: PageState.updating,
      ),
    );
    _usEquityRepository.stopConnection();
    emit(
      state.copyWith(
        type: PageState.success,
      ),
    );
  }

  FutureOr<void> _onGetDividendWeekly(
    GetDividendWeeklyEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        dividendWeeklyState: PageState.loading,
      ),
    );
    DateTime today = DateTime.now();
    ApiResponse response = await _usEquityRepository.getDividends(
      symbols: event.symbols,
      types: const [3],
      startDate: today.addMonths(-1).toString().split(' ')[0],
      endDate: today.addMonths(3).toString().split(' ')[0],
      sortDirection: 0,
    );

    if (response.success) {
      DividendModel dividendModel = DividendModel.fromJson(response.data);
      MapEntry<DateTime, double?>? dividend;
      if (dividendModel.cashDividends?.isNotEmpty == true) {
        final records = dividendModel.cashDividends!
            .where((e) => e.recordDate?.isNotEmpty == true)
            .map(
              (e) {
                return MapEntry<DateTime?, double?>(
                  DateTime.tryParse(e.recordDate!),
                  e.rate,
                );
              },
            )
            .where((e) => e.key != null)
            .map((e) => MapEntry<DateTime, double?>(e.key!, e.value))
            .toList();

        records.sort(
          (a, b) {
            return a.key.compareTo(b.key);
          },
        );

        dividend = records
            .where((e) {
              return e.key.isSameDayOrAfter(today);
            })
            .toList()
            .firstOrNull;

        dividend ??= records
            .where((e) {
              return e.key.isSameDayOrBefore(today);
            })
            .toList()
            .lastOrNull;
      }

      emit(
        state.copyWith(
          dividendWeeklyState: PageState.success,
          dividend: dividend,
        ),
      );
    } else {
      emit(
        state.copyWith(
          dividendWeeklyState: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: 'US06',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetDividendYearly(
    GetDividendYearlyEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        dividendYearlyState: PageState.loading,
      ),
    );

    DateTime today = DateTime.now();

    DateTime oneYearAgo = today.getOneYearAgo(today);

    ApiResponse response = await _usEquityRepository.getDividends(
      symbols: event.symbols,
      types: const [3],
      startDate: oneYearAgo.toString().split(' ')[0],
      endDate: today.toString().split(' ')[0],
      sortDirection: 0,
    );

    if (response.success) {
      DividendModel dividend = DividendModel.fromJson(response.data);

      emit(
        state.copyWith(
          dividendYearlyState: PageState.success,
          dividendYearlyList: dividend.cashDividends,
        ),
      );
    } else {
      emit(
        state.copyWith(
          dividendYearlyState: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: 'US07',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetDividendTwoYear(
    GetDividendTwoYearEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        dividendTwoYearState: PageState.loading,
      ),
    );
    DateTime today = DateTime.now();

    DateTime twoYearAgo = today.getTwoYearAgo(today);

    ApiResponse response = await _usEquityRepository.getDividends(
      symbols: event.symbols,
      types: [3],
      startDate: twoYearAgo.toString().split(' ')[0],
      endDate: today.toString().split(' ')[0],
      sortDirection: 0,
    );

    if (response.success) {
      DividendModel dividend = DividendModel.fromJson(response.data);

      emit(
        state.copyWith(
          dividendTwoYearState: PageState.success,
          dividendTwoYearList: dividend.cashDividends,
        ),
      );
    } else {
      emit(
        state.copyWith(
          dividendTwoYearState: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: 'US08',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetUsIncomingDividends(
    GetUsIncomingDividends event,
    Emitter emit,
  ) async {
    if (event.isFavorite) {
      emit(
        state.copyWith(
          favoriteIncomingDividendsState: PageState.loading,
        ),
      );
    } else {
      emit(
        state.copyWith(
          allIncomingDividendsState: PageState.loading,
        ),
      );
    }

    DateTime startDay = DateTime.now();
    DateTime endDay = startDay.addMonths(2);
    ApiResponse response = await _usEquityRepository.getIncomingDividends(
      types: [3],
      startDate: startDay.toString().split(' ')[0],
      endDate: endDay.toString().split(' ')[0],
      sortDirection: 0,
      onlyFavorites: event.isFavorite,
    );

    if (response.success) {
      List<String> dividends = (response.data['cashDividends'] as List<dynamic>)
          .where((e) {
            if (e['symbol'] == null || e['symbol']?.toString().isEmpty == true) return false;

            final recordDateString = e['recordDate']?.toString();
            if (recordDateString == null || recordDateString.isEmpty) return false;

            try {
              final recordDate = DateTime.parse(recordDateString);
              final recordDay = DateTime(recordDate.year, recordDate.month, recordDate.day);
              final start = DateTime(startDay.year, startDay.month, startDay.day);
              return recordDay.isAfter(start);
            } catch (_) {
              return false;
            }
          })
          .map((e) => e['symbol'].toString())
          .toSet()
          .toList();

      if (event.isFavorite) {
        emit(
          state.copyWith(
            favoriteIncomingDividendsState: PageState.success,
            favoriteIncomingDividends: dividends,
          ),
        );
      } else {
        emit(
          state.copyWith(
            allIncomingDividendsState: PageState.success,
            allIncomingDividends: dividends,
          ),
        );
      }
      event.successCallback?.call();
    } else {
      if (event.isFavorite) {
        emit(
          state.copyWith(
            favoriteIncomingDividendsState: PageState.failed,
            error: PBlocError(
              showErrorWidget: true,
              message: response.error?.message ?? '',
              errorCode: 'US09',
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            allIncomingDividendsState: PageState.failed,
            error: PBlocError(
              showErrorWidget: true,
              message: response.error?.message ?? '',
              errorCode: 'US09',
            ),
          ),
        );
      }
    }
  }

  FutureOr<void> _onSetUsChartCurrentType(
    SetUsChartCurrentType event,
    Emitter emit,
  ) {
    emit(
      state.copyWith(
        currencyType: state.currencyType == CurrencyEnum.dollar ? CurrencyEnum.turkishLira : CurrencyEnum.dollar,
      ),
    );
  }

  FutureOr<void> _onSetUsChartType(
    SetUsChartType event,
    Emitter emit,
  ) {
    emit(
      state.copyWith(
        chartType: event.usChartType,
      ),
    );
  }
}
