import 'package:turkish/turkish.dart';

extension PPStringExtensions on String? {
  bool get isNullOrBlank => this == null || this!.trim().isEmpty;

  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;

  bool get isNotNullOrBlank => this != null && this!.trim().isNotEmpty;

  String? get asNullIfBlank => isNullOrBlank ? null : this;

  String get toCapitalizeCaseTr =>
      turkish.toLowerCase(this!).split(' ').map((word) => turkish.toTitleCase(word)).join(' ');
}
