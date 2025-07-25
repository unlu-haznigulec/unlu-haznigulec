//
//  Generated code. Do not modify.
//  source: RankedSymbols/RankedSymbols.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Line extends $pb.GeneratedMessage {
  factory Line({
    $core.String? symbol,
    $core.Iterable<$core.double>? value,
  }) {
    final $result = create();
    if (symbol != null) {
      $result.symbol = symbol;
    }
    if (value != null) {
      $result.value.addAll(value);
    }
    return $result;
  }
  Line._() : super();
  factory Line.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Line.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Line', package: const $pb.PackageName(_omitMessageNames ? '' : 'messages'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'symbol')
    ..p<$core.double>(2, _omitFieldNames ? '' : 'value', $pb.PbFieldType.PD)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Line clone() => Line()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Line copyWith(void Function(Line) updates) => super.copyWith((message) => updates(message as Line)) as Line;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Line create() => Line._();
  Line createEmptyInstance() => create();
  static $pb.PbList<Line> createRepeated() => $pb.PbList<Line>();
  @$core.pragma('dart2js:noInline')
  static Line getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Line>(create);
  static Line? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get symbol => $_getSZ(0);
  @$pb.TagNumber(1)
  set symbol($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSymbol() => $_has(0);
  @$pb.TagNumber(1)
  void clearSymbol() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.double> get value => $_getList(1);
}

class RankedSymbolsMessage extends $pb.GeneratedMessage {
  factory RankedSymbolsMessage({
    $core.Iterable<Line>? lines,
    $core.Iterable<$core.String>? field,
  }) {
    final $result = create();
    if (lines != null) {
      $result.lines.addAll(lines);
    }
    if (field != null) {
      $result.field.addAll(field);
    }
    return $result;
  }
  RankedSymbolsMessage._() : super();
  factory RankedSymbolsMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RankedSymbolsMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RankedSymbolsMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'messages'), createEmptyInstance: create)
    ..pc<Line>(1, _omitFieldNames ? '' : 'lines', $pb.PbFieldType.PM, subBuilder: Line.create)
    ..pPS(2, _omitFieldNames ? '' : 'field')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RankedSymbolsMessage clone() => RankedSymbolsMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RankedSymbolsMessage copyWith(void Function(RankedSymbolsMessage) updates) => super.copyWith((message) => updates(message as RankedSymbolsMessage)) as RankedSymbolsMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RankedSymbolsMessage create() => RankedSymbolsMessage._();
  RankedSymbolsMessage createEmptyInstance() => create();
  static $pb.PbList<RankedSymbolsMessage> createRepeated() => $pb.PbList<RankedSymbolsMessage>();
  @$core.pragma('dart2js:noInline')
  static RankedSymbolsMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RankedSymbolsMessage>(create);
  static RankedSymbolsMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Line> get lines => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<$core.String> get field => $_getList(1);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
