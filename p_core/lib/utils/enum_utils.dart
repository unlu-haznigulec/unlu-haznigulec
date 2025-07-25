import 'package:flutter/foundation.dart';
import 'package:p_core/utils/string_utils.dart';

class EnumUtils {
  // TestEnum.testEnum => testEnum
  static String? enumToStr(Object? type) => type != null ? describeEnum(type) : null;

  // TestEnum.testEnum => testenum
  static String? enumToLowerCase(Object? type) => StringUtils.lowercase(enumToStr(type));

  // TestEnum.testEnum => test-enum
  static String? enumToParamCase(Object? type) => StringUtils.paramCase(enumToStr(type));

  // TestEnum.testEnum => Test enum
  static String? enumToSentenceCase(Object? type) => StringUtils.sentenceCase(enumToStr(type));

  // TestEnum.testEnum => Test Enum
  static String? enumToTitleCase(Object? type) => StringUtils.titleCase(enumToStr(type));

  // TestEnum.testEnum => TESTENUM
  static String? enumToUpperCase(Object? type) => StringUtils.uppercase(enumToStr(type));
}
