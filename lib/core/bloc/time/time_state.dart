import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/gen/Timestamp/Timestamp.pbserver.dart';

class TimeState extends PState {
  final TimeMessage? mxTime;
  final TimeMessage? bistPPTime;
  final TimeMessage? bistEXTime;
  final TimeMessage? bistViopTime;
  const TimeState({
    super.type = PageState.initial,
    super.error,
    this.mxTime,
    this.bistPPTime,
    this.bistEXTime,
    this.bistViopTime,
  });

  @override
  TimeState copyWith({
    PageState? type,
    PBlocError? error,
    TimeMessage? mxTime,
    TimeMessage? bistPPTime,
    TimeMessage? bistEXTime,
    TimeMessage? bistViopTime,
  }) {
    return TimeState(
      type: type ?? this.type,
      error: error ?? this.error,
      mxTime: mxTime ?? this.mxTime,
      bistPPTime: bistPPTime ?? this.bistPPTime,
      bistEXTime: bistEXTime ?? this.bistEXTime,
      bistViopTime: bistViopTime ?? this.bistViopTime,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        mxTime,
        bistPPTime,
        bistEXTime,
        bistViopTime,
      ];
}
