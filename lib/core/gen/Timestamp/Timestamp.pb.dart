//
//  Generated code. Do not modify.
//  source: Timestamp/Timestamp.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class TimeMessage extends $pb.GeneratedMessage {
  factory TimeMessage({
    $fixnum.Int64? timestamp,
    $core.String? source,
    $core.bool? isBistPPHoliday,
    $core.bool? isBistPPOpen,
  }) {
    final $result = create();
    if (timestamp != null) {
      $result.timestamp = timestamp;
    }
    if (source != null) {
      $result.source = source;
    }
    if (isBistPPHoliday != null) {
      $result.isBistPPHoliday = isBistPPHoliday;
    }
    if (isBistPPOpen != null) {
      $result.isBistPPOpen = isBistPPOpen;
    }
    return $result;
  }
  TimeMessage._() : super();
  factory TimeMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TimeMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TimeMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'messages'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'timestamp')
    ..aOS(2, _omitFieldNames ? '' : 'source')
    ..aOB(3, _omitFieldNames ? '' : 'isBistPPHoliday', protoName: 'isBistPPHoliday')
    ..aOB(4, _omitFieldNames ? '' : 'isBistPPOpen', protoName: 'isBistPPOpen')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TimeMessage clone() => TimeMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TimeMessage copyWith(void Function(TimeMessage) updates) => super.copyWith((message) => updates(message as TimeMessage)) as TimeMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TimeMessage create() => TimeMessage._();
  TimeMessage createEmptyInstance() => create();
  static $pb.PbList<TimeMessage> createRepeated() => $pb.PbList<TimeMessage>();
  @$core.pragma('dart2js:noInline')
  static TimeMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TimeMessage>(create);
  static TimeMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get timestamp => $_getI64(0);
  @$pb.TagNumber(1)
  set timestamp($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTimestamp() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimestamp() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get source => $_getSZ(1);
  @$pb.TagNumber(2)
  set source($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSource() => $_has(1);
  @$pb.TagNumber(2)
  void clearSource() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isBistPPHoliday => $_getBF(2);
  @$pb.TagNumber(3)
  set isBistPPHoliday($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIsBistPPHoliday() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsBistPPHoliday() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isBistPPOpen => $_getBF(3);
  @$pb.TagNumber(4)
  set isBistPPOpen($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasIsBistPPOpen() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsBistPPOpen() => clearField(4);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
