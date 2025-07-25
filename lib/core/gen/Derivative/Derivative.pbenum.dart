//
//  Generated code. Do not modify.
//  source: Derivative/Derivative.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class DerivativeMessage_OptionClass extends $pb.ProtobufEnum {
  static const DerivativeMessage_OptionClass P = DerivativeMessage_OptionClass._(0, _omitEnumNames ? '' : 'P');
  static const DerivativeMessage_OptionClass C = DerivativeMessage_OptionClass._(1, _omitEnumNames ? '' : 'C');

  static const $core.List<DerivativeMessage_OptionClass> values = <DerivativeMessage_OptionClass> [
    P,
    C,
  ];

  static final $core.Map<$core.int, DerivativeMessage_OptionClass> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DerivativeMessage_OptionClass? valueOf($core.int value) => _byValue[value];

  const DerivativeMessage_OptionClass._($core.int v, $core.String n) : super(v, n);
}

class DerivativeMessage_PublishReason extends $pb.ProtobufEnum {
  static const DerivativeMessage_PublishReason UPDATE = DerivativeMessage_PublishReason._(0, _omitEnumNames ? '' : 'UPDATE');
  static const DerivativeMessage_PublishReason REFRESH = DerivativeMessage_PublishReason._(1, _omitEnumNames ? '' : 'REFRESH');

  static const $core.List<DerivativeMessage_PublishReason> values = <DerivativeMessage_PublishReason> [
    UPDATE,
    REFRESH,
  ];

  static final $core.Map<$core.int, DerivativeMessage_PublishReason> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DerivativeMessage_PublishReason? valueOf($core.int value) => _byValue[value];

  const DerivativeMessage_PublishReason._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
