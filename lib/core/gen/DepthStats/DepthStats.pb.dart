//
//  Generated code. Do not modify.
//  source: DepthStats/DepthStats.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class DepthStatsMessage extends $pb.GeneratedMessage {
  factory DepthStatsMessage({
    $fixnum.Int64? timestamp,
    $core.double? totalBidWAvg,
    $core.double? totalAskWAvg,
    $core.double? totalBidQuantity,
    $core.double? totalAskQuantity,
  }) {
    final $result = create();
    if (timestamp != null) {
      $result.timestamp = timestamp;
    }
    if (totalBidWAvg != null) {
      $result.totalBidWAvg = totalBidWAvg;
    }
    if (totalAskWAvg != null) {
      $result.totalAskWAvg = totalAskWAvg;
    }
    if (totalBidQuantity != null) {
      $result.totalBidQuantity = totalBidQuantity;
    }
    if (totalAskQuantity != null) {
      $result.totalAskQuantity = totalAskQuantity;
    }
    return $result;
  }
  DepthStatsMessage._() : super();
  factory DepthStatsMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DepthStatsMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DepthStatsMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'messages'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'timestamp')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'totalBidWAvg', $pb.PbFieldType.OD, protoName: 'totalBidWAvg')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'totalAskWAvg', $pb.PbFieldType.OD, protoName: 'totalAskWAvg')
    ..a<$core.double>(4, _omitFieldNames ? '' : 'totalBidQuantity', $pb.PbFieldType.OD, protoName: 'totalBidQuantity')
    ..a<$core.double>(5, _omitFieldNames ? '' : 'totalAskQuantity', $pb.PbFieldType.OD, protoName: 'totalAskQuantity')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DepthStatsMessage clone() => DepthStatsMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DepthStatsMessage copyWith(void Function(DepthStatsMessage) updates) => super.copyWith((message) => updates(message as DepthStatsMessage)) as DepthStatsMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DepthStatsMessage create() => DepthStatsMessage._();
  DepthStatsMessage createEmptyInstance() => create();
  static $pb.PbList<DepthStatsMessage> createRepeated() => $pb.PbList<DepthStatsMessage>();
  @$core.pragma('dart2js:noInline')
  static DepthStatsMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DepthStatsMessage>(create);
  static DepthStatsMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get timestamp => $_getI64(0);
  @$pb.TagNumber(1)
  set timestamp($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTimestamp() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimestamp() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get totalBidWAvg => $_getN(1);
  @$pb.TagNumber(2)
  set totalBidWAvg($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTotalBidWAvg() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalBidWAvg() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get totalAskWAvg => $_getN(2);
  @$pb.TagNumber(3)
  set totalAskWAvg($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTotalAskWAvg() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalAskWAvg() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get totalBidQuantity => $_getN(3);
  @$pb.TagNumber(4)
  set totalBidQuantity($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTotalBidQuantity() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalBidQuantity() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get totalAskQuantity => $_getN(4);
  @$pb.TagNumber(5)
  set totalAskQuantity($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTotalAskQuantity() => $_has(4);
  @$pb.TagNumber(5)
  void clearTotalAskQuantity() => clearField(5);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
