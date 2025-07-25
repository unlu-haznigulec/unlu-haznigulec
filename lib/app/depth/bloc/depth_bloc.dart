import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/depth/bloc/depth_event.dart';
import 'package:piapiri_v2/app/depth/bloc/depth_state.dart';
import 'package:piapiri_v2/core/api/client/mqtt_depth_controller.dart';
import 'package:piapiri_v2/core/api/model/proto_model/depth/depth_model.dart';
import 'package:piapiri_v2/core/api/model/proto_model/depthstats/depthstats_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class DepthBloc extends PBloc<DepthState> {
  DepthBloc() : super(initialState: const DepthState()) {
    on<ConnectEvent>(_onConnect);
    on<UpdateEvent>(_onUpdate);
    on<UpdateStatsEvent>(_onUpdateStats);
    on<UpdateExtendedEvent>(_onUpdateExtended);
    on<SetStageEvent>(_onSetStage);
    on<DisconnectEvent>(_onDisconnect);
    on<OnSubscribeEvent>(_onSubscribe);
    on<OnSubscribedEvent>(_onSubscribed);
  }

  FutureOr<void> _onConnect(
    ConnectEvent event,
    Emitter<DepthState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    int stage = event.stage;
    int extendedStage = state.extendedStage;
    String matriksSymbolType = stringToSymbolType(event.symbol.type).matriks;
    Map<String, dynamic> topics = getIt<MatriksBloc>().state.topics['mqtt'];
    Map<String, dynamic> depthTopics = topics['depth'];
    Map<String, dynamic>? depthExtendedTopics = topics['depthExtended'];
    bool isExtendedEnabled = depthExtendedTopics != null && depthExtendedTopics[matriksSymbolType] != null;
    if (event.stage > 10) {
      stage = 10;
      if (isExtendedEnabled) {
        extendedStage = event.stage - 10;
      } else {
        extendedStage = 0;
      }
    } else {
      extendedStage = 0;
    }
    await getIt<MqttDepthController>().initializeAndConnect(
      isRealtime: depthTopics[matriksSymbolType]?['qos'] == 'rt',
      onGetDepthData: (Depth depth) {
        add(UpdateEvent(depth: depth));
      },
      onGetDepthStatsData: (DepthStats depthStats) {
        add(UpdateStatsEvent(depthStats: depthStats));
      },
      onGetDepthExtendedData: (Depth depthExtended) {
        add(UpdateExtendedEvent(depth: depthExtended));
      },
      onSubscribe: () {
        add(OnSubscribeEvent());
      },
      onSubscribed: () {
        add(OnSubscribeEvent());
      },
    );
    await getIt<MqttDepthController>().subscribe(symbol: event.symbol);
    if (extendedStage > 0 && isExtendedEnabled) {
      await getIt<MqttDepthController>().subscribe(
        symbol: event.symbol,
        depthType: DepthType.depthExtended,
      );
    }
    if (event.isDepthStatsEnabled) {
      await getIt<MqttDepthController>().subscribe(
        symbol: event.symbol,
        depthType: DepthType.depthstats,
      );
    }
    emit(
      extendedStage == 0
          ? DepthState(
              type: PageState.success,
              depth: state.depth,
              depthStats: state.depthStats,
              stage: stage,
              extendedStage: extendedStage,
            )
          : state.copyWith(
              type: PageState.success,
              stage: stage,
              extendedStage: extendedStage,
            ),
    );
  }

  FutureOr<void> _onUpdate(
    UpdateEvent event,
    Emitter<DepthState> emit,
  ) {
    emit(
      state.copyWith(
        type: PageState.success,
        depth: event.depth,
      ),
    );
  }

  FutureOr<void> _onUpdateStats(
    UpdateStatsEvent event,
    Emitter<DepthState> emit,
  ) {
    emit(
      state.copyWith(
        type: PageState.success,
        depthStats: event.depthStats,
      ),
    );
  }

  FutureOr<void> _onUpdateExtended(
    UpdateExtendedEvent event,
    Emitter<DepthState> emit,
  ) {
    emit(
      state.copyWith(
        type: PageState.success,
        depthExtended: event.depth,
      ),
    );
  }

  FutureOr<void> _onSetStage(
    SetStageEvent event,
    Emitter<DepthState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    int stage = event.stage;
    int extendedStage = state.extendedStage;
    if (event.stage > 10) {
      stage = 10;
      extendedStage = event.stage - 10;
    } else {
      extendedStage = 0;
    }
    if (extendedStage > 0) {
      String matriksSymbolType = stringToSymbolType(event.symbol.type).matriks;

      await getIt<MqttDepthController>().initializeAndConnect(
        isRealtime: getIt<MatriksBloc>().state.topics['mqtt']['depth']?[matriksSymbolType]?['qos'] == 'rt',
        onGetDepthData: (Depth depth) {
          add(UpdateEvent(depth: depth));
        },
        onGetDepthStatsData: (DepthStats depthStats) {
          add(UpdateStatsEvent(depthStats: depthStats));
        },
        onGetDepthExtendedData: (Depth depthExtended) {
          add(UpdateExtendedEvent(depth: depthExtended));
        },
        onSubscribe: () {
          add(OnSubscribeEvent());
        },
        onSubscribed: () {
          add(OnSubscribeEvent());
        },
      );
      await getIt<MqttDepthController>().subscribe(
        symbol: event.symbol,
        depthType: DepthType.depthExtended,
      );
    }

    emit(
      extendedStage == 0
          ? DepthState(
              type: PageState.success,
              depth: state.depth,
              depthStats: state.depthStats,
              stage: stage,
              extendedStage: extendedStage,
            )
          : state.copyWith(
              type: PageState.success,
              stage: stage,
              extendedStage: extendedStage,
            ),
    );
  }

  FutureOr<void> _onDisconnect(
    DisconnectEvent event,
    Emitter<DepthState> emit,
  ) {
    getIt<MqttDepthController>().disconnect();
  }

  FutureOr<void> _onSubscribe(
    OnSubscribeEvent event,
    Emitter<DepthState> emit,
  ) {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
  }

  FutureOr<void> _onSubscribed(
    OnSubscribedEvent event,
    Emitter<DepthState> emit,
  ) {
    emit(
      state.copyWith(
        type: PageState.success,
      ),
    );
  }
}
