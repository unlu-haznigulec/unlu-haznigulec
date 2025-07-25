//
//  Generated code. Do not modify.
//  source: Messenger/Messenger.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class MessengerMessage extends $pb.GeneratedMessage {
  factory MessengerMessage({
    $core.String? code,
    $core.String? from,
    $fixnum.Int64? timestamp,
    $core.String? contentType,
    $core.String? subject,
    $core.String? content,
  }) {
    final $result = create();
    if (code != null) {
      $result.code = code;
    }
    if (from != null) {
      $result.from = from;
    }
    if (timestamp != null) {
      $result.timestamp = timestamp;
    }
    if (contentType != null) {
      $result.contentType = contentType;
    }
    if (subject != null) {
      $result.subject = subject;
    }
    if (content != null) {
      $result.content = content;
    }
    return $result;
  }
  MessengerMessage._() : super();
  factory MessengerMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MessengerMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MessengerMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'messages'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'from')
    ..aInt64(3, _omitFieldNames ? '' : 'timestamp')
    ..a<$core.String>(4, _omitFieldNames ? '' : 'contentType', $pb.PbFieldType.OS, protoName: 'contentType', defaultOrMaker: 'text/plain')
    ..aOS(5, _omitFieldNames ? '' : 'subject')
    ..aOS(6, _omitFieldNames ? '' : 'content')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MessengerMessage clone() => MessengerMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MessengerMessage copyWith(void Function(MessengerMessage) updates) => super.copyWith((message) => updates(message as MessengerMessage)) as MessengerMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessengerMessage create() => MessengerMessage._();
  MessengerMessage createEmptyInstance() => create();
  static $pb.PbList<MessengerMessage> createRepeated() => $pb.PbList<MessengerMessage>();
  @$core.pragma('dart2js:noInline')
  static MessengerMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MessengerMessage>(create);
  static MessengerMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get from => $_getSZ(1);
  @$pb.TagNumber(2)
  set from($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFrom() => $_has(1);
  @$pb.TagNumber(2)
  void clearFrom() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get timestamp => $_getI64(2);
  @$pb.TagNumber(3)
  set timestamp($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTimestamp() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimestamp() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get contentType => $_getS(3, 'text/plain');
  @$pb.TagNumber(4)
  set contentType($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasContentType() => $_has(3);
  @$pb.TagNumber(4)
  void clearContentType() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get subject => $_getSZ(4);
  @$pb.TagNumber(5)
  set subject($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSubject() => $_has(4);
  @$pb.TagNumber(5)
  void clearSubject() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get content => $_getSZ(5);
  @$pb.TagNumber(6)
  set content($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasContent() => $_has(5);
  @$pb.TagNumber(6)
  void clearContent() => clearField(6);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
