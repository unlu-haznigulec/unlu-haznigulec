import 'package:piapiri_v2/core/api/model/proto_model/depth/depth_model.dart';
import 'package:piapiri_v2/core/api/model/proto_model/depthstats/depthstats_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';

class DepthState extends PState {
  final Depth? depth;
  final Depth? depthExtended;
  final int stage;
  final int extendedStage;
  final DepthStats? depthStats;

  const DepthState({
    super.type = PageState.initial,
    super.error,
    this.depth,
    this.depthExtended,
    this.depthStats,
    this.stage = 1,
    this.extendedStage = 0,
  });

  @override
  DepthState copyWith({
    PageState? type,
    PBlocError? error,
    Depth? depth,
    Depth? depthExtended,
    DepthStats? depthStats,
    int? stage,
    int? extendedStage,
  }) {
    return DepthState(
      type: type ?? this.type,
      error: error ?? this.error,
      depth: depth ?? this.depth,
      depthExtended: depthExtended ?? this.depthExtended,
      depthStats: depthStats ?? this.depthStats,
      stage: stage ?? this.stage,
      extendedStage: extendedStage ?? this.extendedStage,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        depth,
        depthStats,
        depthExtended,
        stage,
        extendedStage,
      ];
}
