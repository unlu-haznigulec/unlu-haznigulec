import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p_core/utils/log_utils.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/core/api/client/mqtt_client_helper.dart';
import 'package:piapiri_v2/core/api/client/mqtt_computed_values_controller.dart';
import 'package:piapiri_v2/core/api/client/mqtt_stats_client_helper.dart';
import 'package:piapiri_v2/core/api/client/mqtt_viop_stats_client_helper.dart';
import 'package:piapiri_v2/core/api/client/mqtt_warrant_stats_client_helper.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/model/proto_model/computed_values/computed_values.dart';
import 'package:piapiri_v2/core/api/model/proto_model/derivative/derivative_model.dart';
import 'package:piapiri_v2/core/api/model/proto_model/ranker/ranker_model.dart';
import 'package:piapiri_v2/core/api/model/proto_model/symbol/symbol_model.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_state.dart';
import 'package:piapiri_v2/core/bloc/time/time_bloc.dart';
import 'package:piapiri_v2/core/bloc/time/time_event.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/database/db_helper.dart';
import 'package:piapiri_v2/core/extension/string_extension.dart';
import 'package:piapiri_v2/core/gen/RankedSymbols/RankedSymbols.pb.dart';
import 'package:piapiri_v2/core/model/market_carousel_model.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/ranker_enum.dart';
import 'package:piapiri_v2/core/model/symbol_info_model.dart';
import 'package:piapiri_v2/core/model/symbol_soruce_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/services/price_service.dart';

class SymbolBloc extends PBloc<SymbolState> {
  DatabaseHelper dbHelper = DatabaseHelper();

  SymbolBloc() : super(initialState: const SymbolState()) {
    on<SymbolUpdateListData>(_onUpdateListData);
    on<SymbolSelectItemTemporarily>(_onSelectItemTemporarily);
    on<SymbolGetInfo>(_onGetInfo);
    on<SymbolSubTopicsEvent>(_onSubTopic);
    on<SymbolSubOneTopicEvent>(_onSubOneTopic);
    on<SymbolUnsubsubscribeEvent>(_onUnsubscribe);
    on<SymbolRestartSubscription>(_onRestartSubscription);
    on<SymbolOnGoDetail>(_onGoDetail);
    on<SymbolOnDisposeDetail>(_onDisposeDetail);
    on<SymbolDetailPageEvent>(_onDetailPageEvent);
    on<SymbolRestartTempSelectedItem>(_onRestartTempSelectedItem);
    on<SymbolSubscribeComputedValuesEvent>(_onSubscribeComputedValues);
    on<SymbolSetComputedValuesEvent>(_onSetComputedValues);
    on<SymbolUnsubcribeComputedValuesEvent>(_onUnsubscribeComputedValues);
    on<GetSymbolDetailEvent>(_onGetSymbolDetail);
    on<GetMarketCarouselEvent>(_onGetMarketCarousel);
    on<SymbolIsExistInDBEvent>(_onIsExistSymbolInDB);
    on<SymbolSubscribeStatsEvent>(_onSubscribeStatsEvent);
    on<SymbolUnsubcribeRankerListEvent>(_onUnsubscribeRankerListEvent);
    on<SymbolUpdateEquityRankerListEvent>(_onUpdateEquityRankerListEvent);
    on<SymbolUpdateWarrantRankerListEvent>(_onUpdateWarrantRankerList);
    on<SymbolUpdateViopRankerListEvent>(_onUpdateViopRankerListEvent);
  }

  FutureOr<void> _onUpdateListData(
    SymbolUpdateListData event,
    Emitter<SymbolState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.updating,
      ),
    );
    List<MarketListModel> selectedListItems = List.from(state.watchingItems);
    int symbolIndex = selectedListItems.indexWhere((element) => element.symbolCode == event.symbol.symbolCode);
    MarketListModel? updatedSymbol = selectedListItems.firstWhereOrNull(
      (element) => element.symbolCode == event.symbol.symbolCode,
    );
    if (updatedSymbol == null) {
      List<Map<String, dynamic>> result = await dbHelper.getTypeOfSymbol(event.symbol.symbolCode);
      String symbolType = result.first['TypeCode'];
      updatedSymbol = MarketListModel(
        symbolCode: event.symbol.symbolCode,
        type: symbolType,
        updateDate: '',
        marketCode: result.first['MarketCode'] ?? '',
        swapType: result.first['SwapType'] ?? '',
        actionType: result.first['ActionType'] ?? '',
      );
      symbolIndex = selectedListItems.length;
    }
    if (event.symbol is Derivative) {
      updatedSymbol = updatedSymbol.updateDerivative(event.symbol as Derivative);
    } else {
      updatedSymbol = updatedSymbol.updateSymbol(event.symbol as SymbolModel);
    }
    if (symbolIndex == selectedListItems.length) {
      selectedListItems.add(updatedSymbol);
    } else {
      selectedListItems[symbolIndex] = updatedSymbol;
    }
    emit(
      state.copyWith(
        type: PageState.updated,
        watchingItems: selectedListItems,
        selectedItem: (state.selectedItem.symbolCode) == updatedSymbol.symbolCode ? updatedSymbol : state.selectedItem,
        tempSelectedItem: (state.tempSelectedItem?.symbolCode ?? '') == updatedSymbol.symbolCode
            ? updatedSymbol
            : state.tempSelectedItem,
        conditionSymbol: (state.conditionSymbol?.symbolCode ?? '') == updatedSymbol.symbolCode
            ? updatedSymbol
            : state.conditionSymbol,
        updatedSymbol: updatedSymbol,
        detailSymbol:
            (state.detailSymbol?.symbolCode ?? '') == updatedSymbol.symbolCode ? updatedSymbol : state.detailSymbol,
      ),
    );
  }

  FutureOr<void> _onGoDetail(
    SymbolOnGoDetail event,
    Emitter<SymbolState> emit,
  ) async {
    add(
      SymbolOnDisposeDetail(),
    );

    List<Map<String, dynamic>> detailedSymbols = await dbHelper.getDetailsOfSymbol(event.symbol.symbolCode);

    MarketListModel? selectedItem = getIt<SymbolBloc>().state.watchingItems.firstWhereOrNull(
          (element) => element.symbolCode == event.symbol.symbolCode,
        );
    selectedItem = selectedItem?.copyWith(
      type: detailedSymbols.first['TypeCode'],
      underlying: detailedSymbols.first['UnderlyingName'] ?? '',
      marketCode: detailedSymbols.first['MarketCode'] ?? '',
      exchangeCode: detailedSymbols.first['ExchangeCode'] ?? '',
      swapType: detailedSymbols.first['SwapType'] ?? '',
      actionType: detailedSymbols.first['ActionType'] ?? '',
      description: detailedSymbols.first['Description'] ?? '',
      multiplier: detailedSymbols.first['Multiplier'] ?? '',
      issuer: detailedSymbols.first['Issuer'] ?? '',
    );
    selectedItem ??= event.symbol;
    if (selectedItem.type.isNotEmpty) {
      emit(
        state.copyWith(
          detailSymbol: selectedItem,
        ),
      );
      event.callback?.call(selectedItem);
    }
  }

  FutureOr<void> _onSelectItemTemporarily(
    SymbolSelectItemTemporarily event,
    Emitter<SymbolState> emit,
  ) {
    emit(
      state.copyWith(
        type: PageState.updating,
      ),
    );
    MarketListModel? symbol = state.watchingItems.firstWhereOrNull(
      (element) => element.symbolCode == event.symbol.symbolCode,
    );
    double? priceStep = PriceService.getPriceStep(
      event.symbol.basePrice,
      symbol?.type,
      symbol?.marketCode,
      symbol?.subMarketCode,
    );
    emit(
      state.copyWith(
        type: PageState.updated,
        tempSelectedItem: symbol ??
            MarketListModel(
              symbolCode: event.symbol.symbolCode,
              updateDate: '',
              type: event.symbol.type,
              ask: event.symbol.basePrice,
              bid: event.symbol.basePrice,
              priceStep: priceStep,
            ),
      ),
    );
  }

  FutureOr<void> _onGetInfo(
    SymbolGetInfo event,
    Emitter<SymbolState> emit,
  ) async {
    ApiResponse response = await getIt<PPApi>().matriksService.companyCard(
          event.symbolName,
          getIt<MatriksBloc>().state.endpoints!.rest!.companyCards!.url ?? '',
        );
    if (response.success && response.data.isNotEmpty) {
      SymbolInfoModel symbolInfo = SymbolInfoModel.fromJson(response.data);
      event.callback(symbolInfo);
    }
  }

  FutureOr<void> _onSubTopic(
    SymbolSubTopicsEvent event,
    Emitter<SymbolState> emit,
  ) async {
    if (event.symbols.isNotEmpty) {
      emit(
        state.copyWith(
          type: PageState.fetching,
        ),
      );
      List<MarketListModel> watchingItems = List.from(state.watchingItems);
      for (MarketListModel symbol in event.symbols) {
        if (watchingItems.any((element) => element.symbolCode == symbol.symbolCode)) continue;
        List<Map<String, dynamic>> detailedSymbols = await dbHelper.getDetailsOfSymbol(symbol.symbolCode);
        if (detailedSymbols.isNotEmpty) {
          symbol.copyWith(
            type: detailedSymbols.first['TypeCode'],
            decimalCount: detailedSymbols.first['DecimalCount'] ?? 2,
          );
        }

        watchingItems.add(symbol);
      }
      emit(
        state.copyWith(
          watchingItems: watchingItems.toList(),
          type: PageState.success,
        ),
      );
      List<MarketListModel> symbols = List.from(event.symbols);
      for (MarketListModel symbol in symbols) {
        if (symbol.type != SymbolTypes.fund.name) {
          MqttClientHelper.subscribeSymbol(
            symbol: symbol,
            onGotFirstResponse: (firstResponse) {
              if (event.callback != null) {
                if (firstResponse is SymbolModel) {
                  symbol = symbol.updateSymbol(firstResponse);
                } else {
                  symbol = symbol.updateDerivative(firstResponse as Derivative);
                }
                event.subscribeCallback?.call(symbol);
              }
            },
          );
        }
      }
      event.callback?.call(watchingItems.toList());
    }
  }

  FutureOr<void> _onSubOneTopic(
    SymbolSubOneTopicEvent event,
    Emitter<SymbolState> emit,
  ) async {
    if (event.symbol.isNotNullOrBlank) {
      emit(
        state.copyWith(
          type: PageState.fetching,
        ),
      );
      String symbol0 = event.symbol.trim();
      if (event.symbolType == SymbolTypes.warrant && !event.symbol.endsWith('V') && event.symbol != 'ALTINS1') {
        symbol0 = '${event.symbol}V';
      }
      if (symbol0 == 'ALTIN') {
        symbol0 = '${symbol0}S1';
      }

      List<MarketListModel> watchingItems = List.from(state.watchingItems);
      List<String> watchingSymbolNames = watchingItems.map((e) => e.symbolCode).toList();
      List<Map<String, dynamic>> detailedSymbols = await dbHelper.getDetailsOfSymbol(symbol0);

      int decimalCount = 2;
      if (detailedSymbols.isNotEmpty) {
        MarketListModel symbol = MarketListModel(
          symbolCode: detailedSymbols.first['Name'],
          type: detailedSymbols.first['TypeCode'],
          updateDate: '',
          underlying: detailedSymbols.first['UnderlyingName'] ?? '',
          marketCode: detailedSymbols.first['MarketCode'] ?? '',
          swapType: detailedSymbols.first['SwapType'] ?? '',
          actionType: detailedSymbols.first['ActionType'] ?? '',
          subMarketCode: detailedSymbols.first['SubMarketCode'] ?? '',
          description: detailedSymbols.first['Description'] ?? '',
          decimalCount: detailedSymbols.first['DecimalCount'] ?? 2,
        );
        decimalCount = symbol.decimalCount;
        if (!watchingSymbolNames.contains(symbol.symbolCode)) {
          watchingItems.add(symbol);
        }
        emit(
          state.copyWith(
            watchingItems: watchingItems,
            type: PageState.success,
          ),
        );
        MqttClientHelper.subscribeSymbol(
          symbol: symbol,
          onGotFirstResponse: (firstResponse) {
            if (firstResponse.symbolCode == symbol.symbolCode) {
              LogUtils.pLog('MQTT::GOT_FIRST');
              if (firstResponse is SymbolModel) {
                symbol = symbol.updateSymbol(firstResponse);
              } else {
                symbol = symbol.updateDerivative(firstResponse as Derivative);
              }
              event.callback?.call(symbol);
            }
          },
          onSubscribedAlready: () {
            symbol = state.watchingItems.firstWhere((element) => element.symbolCode == symbol.symbolCode);
            symbol = symbol.copyWith(
              decimalCount: decimalCount,
            );
            event.callback?.call(symbol);
          },
        );
      } else {
        emit(
          state.copyWith(
            type: PageState.success,
          ),
        );
      }
    }
  }

  bool isEquity(MarketListModel symbol) {
    return symbol.type == SymbolTypes.equity.name;
  }

  FutureOr<void> _onUnsubscribe(
    SymbolUnsubsubscribeEvent event,
    Emitter<SymbolState> emit,
  ) async {
    //Carouseldeki semboller ve secili favori listelerinden gelen semboller hariç unsubscribe edilir.
    List<String> ignoreUnsubscribeSymbols = state.marketCarousel
        .where((element) => element.symbolSource == SymbolSourceEnum.matriks)
        .map((e) => e.code)
        .toList();

    if (getIt<FavoriteListBloc>().state.selectedList != null) {
      ignoreUnsubscribeSymbols.addAll(
        getIt<FavoriteListBloc>()
            .state
            .selectedList!
            .favoriteListItems
            .where(
              (element) => element.symbolSource == SymbolSourceEnum.matriks,
            )
            .map((e) => e.symbol)
            .toList(),
      );
    }
    List<String> unsubsListNames = [];
    for (MarketListModel symbol in event.symbolList) {
      if (!ignoreUnsubscribeSymbols.contains(symbol.symbolCode)) {
      MqttClientHelper.unsubscribeSymbol(symbol: symbol);
        unsubsListNames.add(symbol.symbolCode);
      }
    }

    List<MarketListModel> watchingItems =
        state.watchingItems.where((element) => !unsubsListNames.contains(element.symbolCode)).toList();

    emit(
      state.copyWith(
        watchingItems: watchingItems,
      ),
    );
  }

  FutureOr<void> _onRestartSubscription(SymbolRestartSubscription event, Emitter<SymbolState> emit) async {
    MqttClientHelper.disconnect();
    getIt<TimeBloc>().add(TimeConnectEvent());
    for (MarketListModel symbol in state.watchingItems) {
      MqttClientHelper.subscribeSymbol(symbol: symbol);
    }
  }

  FutureOr<void> _onDisposeDetail(SymbolOnDisposeDetail event, Emitter<SymbolState> emit) {
    emit(
      state.copyWith(
        detailSymbol: state.detailSymbol?.copyWith(
          bid: 0,
          symbolCode: 'A',
          updateDate: '',
        ),
      ),
    );
  }

  FutureOr<void> _onDetailPageEvent(
    SymbolDetailPageEvent event,
    Emitter<SymbolState> emit,
  ) async {
    MarketListModel? symbol = event.symbolData;
    if (event.symbol != null) {
      String symbolName = event.symbol!.symbolCode;

      List<Map<String, dynamic>> symbolData = await dbHelper.getDetailsOfSymbol(symbolName);

      if (symbolData[0]['TypeCode'] == SymbolTypes.undefined.name) return;

      symbol = getIt<SymbolBloc>().state.watchingItems.firstWhereOrNull(
            (element) => element.symbolCode == symbolName,
          );
      symbol ??= MarketListModel(
        symbolCode: symbolName,
        updateDate: '',
        type: symbolData[0]['TypeCode'].toString(),
        issuer: symbolData[0]['Issuer'].toString(),
      );
    }

    getIt<SymbolBloc>().add(
      SymbolOnGoDetail(
        symbol: symbol!,
      ),
    );
    if (router.routeNames.isNotEmpty && router.routeNames.contains(SymbolDetailRoute.name)) {
      router.maybePop();
    }
    router.push(
      SymbolDetailRoute(
        symbol: symbol,
      ),
    );
  }

  FutureOr<void> _onRestartTempSelectedItem(SymbolRestartTempSelectedItem event, Emitter<SymbolState> emit) {
    emit(
      state.restartTempSelectedItem(),
    );
  }

  FutureOr<void> _onSubscribeComputedValues(
    SymbolSubscribeComputedValuesEvent event,
    Emitter<SymbolState> emit,
  ) async {
    Map<String, dynamic> computedValuesDetail = _prepareComputedValuesTopic(event.symbolType);
    if (computedValuesDetail.isNotEmpty) {
      String computedValuesTopicWithSymbol = computedValuesDetail['computedValuesTopic'].replaceAll(
        '%s',
        event.symbolCode,
      );
      MqttComputedValuesController computedValuesController = MqttComputedValuesController();
      await computedValuesController.initializeAndConnect(
        isRealtime: computedValuesDetail['isRealtime'],
        symbolType: stringToSymbolType(event.symbolType),
        onGetData: (values) {
          add(SymbolSetComputedValuesEvent(computedValues: values));
          log('GOT::DATA');
        },
      );
      computedValuesController.subscribe(
        topic: computedValuesTopicWithSymbol,
        onGotFirstResponse: (values) {
          add(SymbolSetComputedValuesEvent(computedValues: values));
          log('GOT::DATA');
        },
      );
    }
  }

  FutureOr<void> _onSetComputedValues(
    SymbolSetComputedValuesEvent event,
    Emitter<SymbolState> emit,
  ) {
    if (event.computedValues != null) {
      List<ComputedValues> computedValues = List.from(state.computedValues);
      int index = computedValues.indexWhere((e) => e.symbol == event.computedValues!.symbol);
      if (index > -1) {
        computedValues[index] = event.computedValues!;
      } else {
        computedValues.add(event.computedValues!);
      }
      emit(
        state.copyWith(
          computedValues: computedValues,
        ),
      );
    }
  }

  FutureOr<void> _onUnsubscribeComputedValues(SymbolUnsubcribeComputedValuesEvent event, Emitter<SymbolState> emit) {
    Map<String, dynamic> computedValuesDetail = _prepareComputedValuesTopic(event.symbolType);
    if (computedValuesDetail.isNotEmpty) {
      String topic = computedValuesDetail['computedValuesTopic'].replaceAll(
        '%s',
        event.symbolCode,
      );
      MqttComputedValuesController().unSubscribeToMQTT(topic: topic);
      emit(
        state.restartComputedValues(),
      );
    }
  }

  Map<String, dynamic> _prepareComputedValuesTopic(String symbolType) {
    Map<String, dynamic>? symbolDetail =
        getIt<MatriksBloc>().state.topics['mqtt']['analytics'][symbolType.toLowerCase()];
    String computedValuesTopic = '';
    bool isRealtime = false;
    if (symbolDetail != null) {
      computedValuesTopic = symbolDetail['topic'];
      isRealtime = symbolDetail['qos'] == 'rt';
      return {
        'computedValuesTopic': computedValuesTopic,
        'isRealtime': isRealtime,
      };
    }
    return {};
  }

  FutureOr<void> _onGetSymbolDetail(
    GetSymbolDetailEvent event,
    Emitter<SymbolState> emit,
  ) async {
    List<Map<String, dynamic>> symbolData = await dbHelper.getDetailsOfSymbol(event.symbolName);
    MarketListModel symbol = MarketListModel(
      symbolCode: symbolData.first['Name'],
      type: symbolData.first['TypeCode'],
      symbolType: symbolData.first['TypeCode'],
      underlying: symbolData.first['UnderlyingName'] ?? '',
      marketCode: symbolData.first['MarketCode'] ?? '',
      exchangeCode: symbolData.first['ExchangeCode'] ?? '',
      subMarketCode: symbolData.first['SubMarketCode'] ?? '',
      swapType: symbolData.first['SwapType'] ?? '',
      maturity: symbolData.first['MaturityDate'] ?? '',
      actionType: symbolData.first['ActionType'] ?? '',
      description: symbolData.first['Description'] ?? '',
      multiplier: symbolData.first['Multiplier'] ?? '',
      issuer: symbolData.first['Issuer'] ?? '',
      optionType: symbolData.first['OptionType'] ?? '',
      optionClass: symbolData.first['OptionClass'] ?? '',
      sectorCode: symbolData.first['SectorCode'] ?? '',
      tradeStatus: symbolData.first['TradeStatus'] ?? '',
      updateDate: '',
    );
    event.callback(symbol);
  }

  /// Remote Configten semboller cekilir ve gerekli yerlere subscribe olunur.
  FutureOr<void> _onGetMarketCarousel(
    GetMarketCarouselEvent event,
    Emitter<SymbolState> emit,
  ) async {
    Map<String, dynamic> marketCarouselJson = jsonDecode(remoteConfig.getString('marketCarousel'));
    List<MarketCarouselModel> marketCarousel = [
      ...marketCarouselJson['MarketCarousel'].map((e) => MarketCarouselModel.fromJson(e))
    ];
    event.callback?.call(marketCarousel);
    add(
      SymbolSubTopicsEvent(
        symbols: marketCarousel
            .where((element) => element.symbolSource == SymbolSourceEnum.matriks)
            .map(
              (e) => MarketListModel(
                symbolCode: e.code,
                type: e.symbolType.dbKey,
                updateDate: '',
              ),
            )
            .toList(),
      ),
    );
    getIt<UsEquityBloc>().add(
      SubscribeSymbolEvent(
        symbolName: marketCarousel
            .where((element) => element.symbolSource == SymbolSourceEnum.alpaca)
            .map((e) => e.code)
            .toList(),
      ),
    );
    emit(
      state.copyWith(
        marketCarousel: marketCarousel,
      ),
    );
  }

  FutureOr<void> _onIsExistSymbolInDB(
    SymbolIsExistInDBEvent event,
    Emitter<SymbolState> emit,
  ) async {
    String symbolName;

    symbolName = event.symbol;

    if (symbolName.endsWith('.R')) {
      symbolName = symbolName.replaceAll('.R', 'R');
    }

    bool isExist = await dbHelper.hasSymbolInDB(symbolName);

    if (event.symbolTypes == SymbolTypes.equity) {
      List<Map<String, dynamic>> etfSymbol = await dbHelper.getEtfSymbolName(symbolName);
      if (etfSymbol.isNotEmpty) {
        isExist = true;
        symbolName = etfSymbol[0]['Name'];
      }
    }

    event.hasInDB(isExist, symbolName);
  }

  Future<void> _onSubscribeStatsEvent(
    SymbolSubscribeStatsEvent event,
    Emitter<SymbolState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.updating,
        rankerEnum: event.rankerEnum,
      ),
    );

    if (event.rankerEnum == RankerEnum.warrant) {
      MqttWarrantStatsClientHelper.subscribe(
        statsKey: event.statsKey,
        unsubStatsKey: state.rankerKey,
      );
    }

    if (event.rankerEnum == RankerEnum.future) {
      MqttViopStatsClientHelper.subscribe(
        statsKey: event.statsKey,
        unsubStatsKey: event.unsubscribeKey,
      );
    }
    if (event.rankerEnum == RankerEnum.equity) {
      MqttStatsClientHelper.subscribe(
        statsKey: event.statsKey,
        unsubStatsKey: state.rankerKey,
      );
    }

    emit(
      state.copyWith(
        type: PageState.updated,
        rankerKey: event.statsKey,
      ),
    );
  }

  FutureOr<void> _onUnsubscribeRankerListEvent(
    SymbolUnsubcribeRankerListEvent event,
    Emitter<SymbolState> emit,
  ) {
    if (event.rankerEnum == RankerEnum.warrant) {
      MqttWarrantStatsClientHelper.unsubcribe(
        statsKey: event.statsKey,
      );
    }

    if (event.rankerEnum == RankerEnum.future) {
      MqttViopStatsClientHelper.unsubcribe(
        statsKey: event.statsKey,
      );
    }
    if (event.rankerEnum == RankerEnum.equity) {
      MqttStatsClientHelper.unsubcribe(
        statsKey: event.statsKey,
      );
    }
  }

  FutureOr<void> _onUpdateEquityRankerListEvent(
    SymbolUpdateEquityRankerListEvent event,
    Emitter<SymbolState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.updating,
      ),
    );
    List<MarketListModel> marketListModels = [];
    if (state.equityRankerList.isNotEmpty) {
      marketListModels.addAll(state.equityRankerList);
    }
    List<String> oldRankerListNames = marketListModels.map((e) => e.symbolCode).toList();

    List<Ranker> subscribeList = event.rankerList.where((item) => !oldRankerListNames.contains(item.key)).toList();

    if (subscribeList.isNotEmpty) {
      List<Map<String, dynamic>> symboldetails =
          await dbHelper.getDetailsOfSymbols(subscribeList.map((e) => e.key).toList());

      marketListModels.addAll(symboldetails
          .map((e) => MarketListModel(
                symbolCode: e['Name'],
                description: e['Description'] ?? '',
                maturity: e['MaturityDate'] ?? '',
                type: e['TypeCode'],
                updateDate: '',
                underlying: e['UnderlyingName'] ?? '',
                marketCode: e['MarketCode'] ?? '',
                swapType: e['SwapType'] ?? '',
                actionType: e['ActionType'] ?? '',
                optionClass: e['OptionClass'] ?? '',
                subMarketCode: e['SubMarketCode'] ?? '',
                decimalCount: e['DecimalCount'] ?? 2,
              ))
          .toList());
    }
    List<MarketListModel> watchingItems = [];

    for (Ranker element in event.rankerList) {
      MarketListModel? symbol = marketListModels.firstWhereOrNull((e) => e.symbolCode == element.key);
      if (symbol == null) continue;

      watchingItems.add(symbol.copyWith(
        last: element.last,
        // yuzde degisim olarak hisselerde priceChange kullanilirken varantlarda yukselen ve dusenler listesinde value kullanilir
        differencePercent: element.priceChange,
        ask: element.ask,
        bid: element.bid,
        volume: element.value,
      ));
    }
    emit(
      state.copyWith(
        equityRankerList: watchingItems,
        type: PageState.updated,
      ),
    );
  }

  FutureOr<void> _onUpdateWarrantRankerList(
    SymbolUpdateWarrantRankerListEvent event,
    Emitter<SymbolState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.updating,
      ),
    );
    List<MarketListModel> marketListModels = [];
    if (state.warrantRankerList.isNotEmpty) {
      marketListModels.addAll(state.warrantRankerList);
    }
    List<String> oldRankerListNames = marketListModels.map((e) => e.symbolCode).toList();

    List<Ranker> subscribeList = event.rankerList.where((item) => !oldRankerListNames.contains(item.key)).toList();

    if (subscribeList.isNotEmpty) {
      List<Map<String, dynamic>> symboldetails =
          await dbHelper.getDetailsOfSymbols(subscribeList.map((e) => e.key).toList());

      marketListModels.addAll(symboldetails
          .map((e) => MarketListModel(
                symbolCode: e['Name'],
                description: e['Description'] ?? '',
                maturity: e['MaturityDate'] ?? '',
                type: e['TypeCode'],
                updateDate: '',
                underlying: e['UnderlyingName'] ?? '',
                marketCode: e['MarketCode'] ?? '',
                swapType: e['SwapType'] ?? '',
                actionType: e['ActionType'] ?? '',
                optionClass: e['OptionClass'] ?? '',
                subMarketCode: e['SubMarketCode'] ?? '',
                decimalCount: e['DecimalCount'] ?? 2,
              ))
          .toList());
    }
    List<MarketListModel> watchingItems = [];

    for (Ranker element in event.rankerList) {
      MarketListModel? symbol = marketListModels.firstWhereOrNull((e) => e.symbolCode == element.key);
      if (symbol == null) continue;

      watchingItems.add(symbol.copyWith(
        last: element.last,
        // yuzde degisim olarak hisselerde priceChange kullanilirken varantlarda yukselen ve dusenler listesinde value kullanilir
        differencePercent: element.value,
        ask: element.ask,
        bid: element.bid,
        volume: element.value,
      ));
    }
    emit(
      state.copyWith(
        warrantRankerList: watchingItems,
        type: PageState.updated,
      ),
    );
  }

  FutureOr<void> _onUpdateViopRankerListEvent(
    SymbolUpdateViopRankerListEvent event,
    Emitter<SymbolState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.updating,
      ),
    );

    List<MarketListModel> marketListModels = [];
    if (state.viopRankerList.isNotEmpty) {
      marketListModels.addAll(state.equityRankerList);
    }
    List<String> oldRankerListNames = marketListModels.map((e) => e.symbolCode).toList();

    List<Line> subscribeList =
        event.rankedSymbols.lines.where((item) => !oldRankerListNames.contains(item.symbol)).toList();

    if (subscribeList.isNotEmpty) {
      List<Map<String, dynamic>> symboldetails =
          await dbHelper.getDetailsOfSymbols(subscribeList.map((e) => e.symbol).toList());

      marketListModels.addAll(symboldetails
          .map((e) => MarketListModel(
                symbolCode: e['Name'],
                description: e['Description'] ?? '',
                maturity: e['MaturityDate'] ?? '',
                type: e['TypeCode'],
                updateDate: '',
                underlying: e['UnderlyingName'] ?? '',
                marketCode: e['MarketCode'] ?? '',
                swapType: e['SwapType'] ?? '',
                actionType: e['ActionType'] ?? '',
                subMarketCode: e['SubMarketCode'] ?? '',
                decimalCount: e['DecimalCount'] ?? 2,
              ))
          .toList());
    }
    List<MarketListModel> watchingItems = [];

    for (Line element in event.rankedSymbols.lines) {
      MarketListModel? symbol = marketListModels.firstWhereOrNull((e) => e.symbolCode == element.symbol);
      if (symbol == null) continue;

      watchingItems.add(
        symbol.copyWith(
          bid: element.value[0],
          ask: element.value[1],
          last: element.value[2],
          differencePercent: element.value[3],
          dailyHigh: element.value[4],
          dailyLow: element.value[5],
        ),
      );
    }

    emit(
      state.copyWith(
        viopRankerList: watchingItems,
        type: PageState.updated,
      ),
    );
  }
}
