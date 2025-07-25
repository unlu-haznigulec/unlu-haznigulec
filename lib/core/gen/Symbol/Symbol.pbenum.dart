//
//  Generated code. Do not modify.
//  source: Symbol/Symbol.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class SymbolMessage_PublishReason extends $pb.ProtobufEnum {
  static const SymbolMessage_PublishReason UPDATE = SymbolMessage_PublishReason._(0, _omitEnumNames ? '' : 'UPDATE');
  static const SymbolMessage_PublishReason REFRESH = SymbolMessage_PublishReason._(1, _omitEnumNames ? '' : 'REFRESH');

  static const $core.List<SymbolMessage_PublishReason> values = <SymbolMessage_PublishReason> [
    UPDATE,
    REFRESH,
  ];

  static final $core.Map<$core.int, SymbolMessage_PublishReason> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SymbolMessage_PublishReason? valueOf($core.int value) => _byValue[value];

  const SymbolMessage_PublishReason._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
