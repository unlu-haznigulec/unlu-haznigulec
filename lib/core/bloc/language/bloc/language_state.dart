import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';

class LanguageState extends PState {
  final String languageCode;
  final String countryCode;
  final Map<String, dynamic> keys;

  const LanguageState({
    PageState type = PageState.initial,
    PBlocError? error,
    this.languageCode = 'tr',
    this.countryCode = 'TR',
    this.keys = const {},
  }) : super(
          type: type,
          error: error,
        );

  @override
  LanguageState copyWith({
    PageState? type,
    PBlocError? error,
    String? languageCode,
    String? countryCode,
    Map<String, dynamic>? keys,
  }) {
    return LanguageState(
      type: type ?? this.type,
      error: error ?? this.error,
      languageCode: languageCode ?? this.languageCode,
      countryCode: countryCode ?? this.countryCode,
      keys: keys ?? this.keys,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        languageCode,
        countryCode,
        keys,
      ];
}
