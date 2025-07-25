//
//  Generated code. Do not modify.
//  source: DepthTable/DepthTable.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class DepthTableMessage_Action extends $pb.ProtobufEnum {
  static const DepthTableMessage_Action I = DepthTableMessage_Action._(0, _omitEnumNames ? '' : 'I');
  static const DepthTableMessage_Action U = DepthTableMessage_Action._(1, _omitEnumNames ? '' : 'U');
  static const DepthTableMessage_Action D = DepthTableMessage_Action._(2, _omitEnumNames ? '' : 'D');

  static const $core.List<DepthTableMessage_Action> values = <DepthTableMessage_Action> [
    I,
    U,
    D,
  ];

  static final $core.Map<$core.int, DepthTableMessage_Action> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DepthTableMessage_Action? valueOf($core.int value) => _byValue[value];

  const DepthTableMessage_Action._($core.int v, $core.String n) : super(v, n);
}

class DepthTableMessage_BidAsk extends $pb.ProtobufEnum {
  static const DepthTableMessage_BidAsk A = DepthTableMessage_BidAsk._(0, _omitEnumNames ? '' : 'A');
  static const DepthTableMessage_BidAsk B = DepthTableMessage_BidAsk._(1, _omitEnumNames ? '' : 'B');

  static const $core.List<DepthTableMessage_BidAsk> values = <DepthTableMessage_BidAsk> [
    A,
    B,
  ];

  static final $core.Map<$core.int, DepthTableMessage_BidAsk> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DepthTableMessage_BidAsk? valueOf($core.int value) => _byValue[value];

  const DepthTableMessage_BidAsk._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
