import 'package:piapiri_v2/core/api/model/proto_model/depth/depth_model.dart';
import 'package:piapiri_v2/core/api/model/proto_model/depthstats/depthstats_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';

abstract class DepthEvent extends PEvent {}

class ConnectEvent extends DepthEvent {
  final MarketListModel symbol;
  final bool isExtended;
  final bool isDepthStatsEnabled;
  final bool isDepthExtendedEnabled;
  final int stage;

  ConnectEvent({
    required this.symbol,
    this.isExtended = false,
    this.isDepthStatsEnabled = false,
    this.isDepthExtendedEnabled = false,
    required this.stage,
  });
}

class UpdateEvent extends DepthEvent {
  final Depth depth;

  UpdateEvent({
    required this.depth,
  });
}

class UpdateExtendedEvent extends DepthEvent {
  final Depth depth;

  UpdateExtendedEvent({
    required this.depth,
  });
}

class UpdateStatsEvent extends DepthEvent {
  final DepthStats depthStats;

  UpdateStatsEvent({
    required this.depthStats,
  });
}

class SetStageEvent extends DepthEvent {
  final MarketListModel symbol;
  final int stage;

  SetStageEvent({
    required this.symbol,
    required this.stage,
  });
}

class DisconnectEvent extends DepthEvent {}

class OnSubscribeEvent extends DepthEvent {}

class OnSubscribedEvent extends DepthEvent {}
