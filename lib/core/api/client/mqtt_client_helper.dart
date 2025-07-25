import 'package:collection/collection.dart';
import 'package:piapiri_v2/core/api/client/mqtt_dl_symbol_controller.dart';
import 'package:piapiri_v2/core/api/client/mqtt_rt_symbol_controller.dart';
import 'package:piapiri_v2/core/api/model/proto_model/base_symbol/base_symbol.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:tw_queue/tw_queue.dart';

class MqttClientHelper {
  static void subscribeSymbol({
    required MarketListModel symbol,
    Function(BaseSymbol)? onGotFirstResponse,
    Function()? onSubscribedAlready,
  }) async {
    getIt<TWQueue>(instanceName: 'MQTT').add(
      () => _prepareSubscription(
        symbol: symbol,
        onGotFirstResponse: onGotFirstResponse,
        onSubcribedAlready: onSubscribedAlready,
      ),
    );
  }

  static void subscribeTimeStamp({
    Function(BaseSymbol)? onGotFirstResponse,
    Function()? onSubscribedAlready,
  }) async {
    getIt<TWQueue>(instanceName: 'MQTT').add(
      () async {
        String topic = 'mx/timestamp';
        await getIt<MqttRTSymbolController>().initializeAndConnect(
          onGetData: (symbol) => getIt<SymbolBloc>().add(
            SymbolUpdateListData(
              symbol: symbol,
            ),
          ),
        );
        if (getIt<MqttRTSymbolController>().isSubscribed(topic: topic)) {
          onSubscribedAlready?.call();
        } else {
          getIt<MqttRTSymbolController>().subscribe(
            topic: topic,
            onGotFirstResponse: onGotFirstResponse,
          );
        }
      },
    );
  }

  static Future<void> _subscribeToDL(
    String topic,
    Function(BaseSymbol)? onGotFirstResponse,
    Function()? onSubcribedAlready,
  ) async {
    await getIt<MqttDLSymbolController>().initializeAndConnect(
      onGetData: (symbol) => getIt<SymbolBloc>().add(
        SymbolUpdateListData(
          symbol: symbol,
        ),
      ),
    );
    if (getIt<MqttDLSymbolController>().isSubscribed(topic: topic)) {
      onSubcribedAlready?.call();
    } else {
      getIt<MqttDLSymbolController>().subscribe(
        topic: topic,
        onGotFirstResponse: onGotFirstResponse,
      );
    }
  }

  static Future<void> _subscribeToRT(
    String topic,
    Function(BaseSymbol)? onGotFirstResponse,
    Function()? onSubcribedAlready,
  ) async {
    await getIt<MqttRTSymbolController>().initializeAndConnect(
      onGetData: (symbol) => getIt<SymbolBloc>().add(
        SymbolUpdateListData(
          symbol: symbol,
        ),
      ),
    );
    if (getIt<MqttRTSymbolController>().isSubscribed(topic: topic)) {
      onSubcribedAlready?.call();
    } else {
      getIt<MqttRTSymbolController>().subscribe(
        topic: topic,
        onGotFirstResponse: onGotFirstResponse,
      );
    }
  }

  static void _unsubscribeFromDL(
    String topic,
  ) async {
    await getIt<MqttDLSymbolController>().initializeAndConnect(
      onGetData: (symbol) => getIt<SymbolBloc>().add(
        SymbolUpdateListData(
          symbol: symbol,
        ),
      ),
    );
    getIt<MqttDLSymbolController>().unSubscribeToMQTT(
      topic: topic,
    );
  }

  static void _unsubscribeFromRT(
    String topic,
  ) async {
    await getIt<MqttRTSymbolController>().initializeAndConnect(
      onGetData: (symbol) => getIt<SymbolBloc>().add(
        SymbolUpdateListData(
          symbol: symbol,
        ),
      ),
    );
    getIt<MqttRTSymbolController>().unSubscribeToMQTT(
      topic: topic,
    );
  }

  static void _subscribeVQ(
    Map<String, dynamic> mqttTopics,
    String symbolType,
    String symbolCode,
    Function(BaseSymbol)? onGotFirstResponse,
    Function()? onSubcribedAlready,
  ) {
    Map<String, dynamic> symbolDetail = mqttTopics['market'][symbolType];
    Map<String, dynamic>? symbolCodeException = _exceptionChecker(
      symbolDetail,
      symbolCode,
      true,
    );
    String vqTopic = '';
    bool isRealtime = false;
    if (symbolCodeException != null) {
      vqTopic = symbolCodeException['topic'];
      isRealtime = symbolCodeException['qos'] == 'rt';
    } else if (mqttTopics['VQ'] != null && mqttTopics['VQ'][symbolType] != null) {
      vqTopic = mqttTopics['VQ'][symbolType]['topic'];
      isRealtime = mqttTopics['VQ'][symbolType]['qos'] == 'rt';
    }
    if (vqTopic.isNotEmpty) {
      String vqTopicWithSymbol = vqTopic.replaceAll(
        '%s',
        symbolCode,
      );
      if (isRealtime) {
        _subscribeToRT(
          vqTopicWithSymbol,
          onGotFirstResponse,
          onSubcribedAlready,
        );
      } else {
        _subscribeToDL(
          vqTopicWithSymbol,
          onGotFirstResponse,
          onSubcribedAlready,
        );
      }
    }
  }

  static void _unsubscribeVQ(
    Map<String, dynamic> mqttTopics,
    String symbolType,
    String symbolCode,
  ) {
    if (mqttTopics['VQ'] != null && mqttTopics['VQ'][symbolType] != null) {
      String vqTopic = mqttTopics['VQ'][symbolType]['topic'];
      bool isRealtime = mqttTopics['VQ'][symbolType]['qos'] == 'rt';
      String vqTopicWithSymbol = vqTopic.replaceAll(
        '%s',
        symbolCode,
      );
      if (isRealtime) {
        _unsubscribeFromRT(
          vqTopicWithSymbol,
        );
      } else {
        _unsubscribeFromDL(
          vqTopicWithSymbol,
        );
      }
    }
  }

  static Future<void> _prepareSubscription({
    required MarketListModel symbol,
    Function(BaseSymbol)? onGotFirstResponse,
    Function()? onSubcribedAlready,
  }) async {
    SymbolTypes symbolType = stringToSymbolType(symbol.type);
    Map<String, dynamic> mqttTopics = getIt<MatriksBloc>().state.topics['mqtt'];
    Map<String, dynamic> symbolDetail = mqttTopics['market'][symbolType.matriks];
    Map<String, dynamic>? symbolCodeException = _exceptionChecker(
      symbolDetail,
      symbol.symbolCode,
      false,
    );
    String topicFormat = symbolCodeException?['topic'] ?? symbolDetail['topic'];
    bool isRealtime = (symbolCodeException?['qos'] ?? symbolDetail['qos']) == 'rt';
    String topic = topicFormat.replaceAll(
      '%s',
      symbol.symbolCode,
    );

    if (isRealtime) {
      await _subscribeToRT(topic, onGotFirstResponse, onSubcribedAlready);
    } else {
      await _subscribeToDL(topic, onGotFirstResponse, onSubcribedAlready);
    }
    _subscribeVQ(
      mqttTopics,
      symbolType.matriks,
      symbol.symbolCode,
      onGotFirstResponse,
      onSubcribedAlready,
    );
  }

  void reSubscribeSymbols(bool isConnected) {
    if (!isConnected) {
      List<MarketListModel> selectedListItems = List.from(getIt<SymbolBloc>().state.watchingItems);

      getIt<SymbolBloc>().add(
        SymbolSubTopicsEvent(
          symbols: selectedListItems,
        ),
      );
    }
  }

  static Map<String, dynamic>? _exceptionChecker(
    Map<String, dynamic> symbolDetail,
    String symbolCode,
    bool checkVq,
  ) {
    if (symbolDetail['additionalException'] != null) {
      List<dynamic> symbolCodeExceptions = (symbolDetail['additionalException'] as List<dynamic>)
          .where((element) => element['code'] == 'symbolCode')
          .toList();

      if (symbolCodeExceptions.isNotEmpty) {
        Map<String, dynamic>? symbolCodeException = symbolCodeExceptions.firstWhereOrNull(
          (element) =>
              (element['value'] as List<dynamic>).contains(symbolCode) &&
              element['topic'].toString().endsWith('vq') == checkVq,
        );
        return symbolCodeException;
      }
    }
    return null;
  }

  static void unsubscribeSymbol({
    required MarketListModel symbol,
  }) async {
    SymbolTypes symbolType = stringToSymbolType(symbol.type);
    Map<String, dynamic> mqttTopics = getIt<MatriksBloc>().state.topics['mqtt'];
    String topicFormat = mqttTopics['market'][symbolType.matriks]['topic'];
    bool isRealtime = mqttTopics['market'][symbolType.matriks]['qos'] == 'rt';
    String topic = topicFormat.replaceAll(
      '%s',
      symbol.symbolCode,
    );
    if (isRealtime) {
      _unsubscribeFromRT(topic);
    } else {
      _unsubscribeFromDL(topic);
    }
    _unsubscribeVQ(
      mqttTopics,
      symbolType.matriks,
      symbol.symbolCode,
    );
  }

  static void disconnect() {
    getIt<MqttRTSymbolController>().disconnect();
    getIt<MqttDLSymbolController>().disconnect();
  }
}
