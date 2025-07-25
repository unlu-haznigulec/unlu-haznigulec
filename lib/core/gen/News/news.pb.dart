//
//  Generated code. Do not modify.
//  source: News/news.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class RelatedNews extends $pb.GeneratedMessage {
  factory RelatedNews({
    $core.String? id,
    $core.String? headline,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (headline != null) {
      $result.headline = headline;
    }
    return $result;
  }
  RelatedNews._() : super();
  factory RelatedNews.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RelatedNews.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RelatedNews', package: const $pb.PackageName(_omitMessageNames ? '' : 'messages'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'id')
    ..aQS(2, _omitFieldNames ? '' : 'headline')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RelatedNews clone() => RelatedNews()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RelatedNews copyWith(void Function(RelatedNews) updates) => super.copyWith((message) => updates(message as RelatedNews)) as RelatedNews;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RelatedNews create() => RelatedNews._();
  RelatedNews createEmptyInstance() => create();
  static $pb.PbList<RelatedNews> createRepeated() => $pb.PbList<RelatedNews>();
  @$core.pragma('dart2js:noInline')
  static RelatedNews getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RelatedNews>(create);
  static RelatedNews? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get headline => $_getSZ(1);
  @$pb.TagNumber(2)
  set headline($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasHeadline() => $_has(1);
  @$pb.TagNumber(2)
  void clearHeadline() => clearField(2);
}

class NewsMessage extends $pb.GeneratedMessage {
  factory NewsMessage({
    $core.String? id,
    $core.bool? isFlash,
    $core.bool? deleted,
    $fixnum.Int64? timestamp,
    $core.String? headline,
    $core.String? content,
    $core.Iterable<$core.String>? source,
    $core.Iterable<$core.String>? category,
    $core.Iterable<$core.String>? symbol,
    $core.String? language,
    $core.Iterable<$core.String>? attachment,
    $core.String? dailyNewsNo,
    $core.String? chainId,
    $core.Iterable<RelatedNews>? relatedNews,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (isFlash != null) {
      $result.isFlash = isFlash;
    }
    if (deleted != null) {
      $result.deleted = deleted;
    }
    if (timestamp != null) {
      $result.timestamp = timestamp;
    }
    if (headline != null) {
      $result.headline = headline;
    }
    if (content != null) {
      $result.content = content;
    }
    if (source != null) {
      $result.source.addAll(source);
    }
    if (category != null) {
      $result.category.addAll(category);
    }
    if (symbol != null) {
      $result.symbol.addAll(symbol);
    }
    if (language != null) {
      $result.language = language;
    }
    if (attachment != null) {
      $result.attachment.addAll(attachment);
    }
    if (dailyNewsNo != null) {
      $result.dailyNewsNo = dailyNewsNo;
    }
    if (chainId != null) {
      $result.chainId = chainId;
    }
    if (relatedNews != null) {
      $result.relatedNews.addAll(relatedNews);
    }
    return $result;
  }
  NewsMessage._() : super();
  factory NewsMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory NewsMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'NewsMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'messages'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'id')
    ..aOB(2, _omitFieldNames ? '' : 'isFlash', protoName: 'isFlash')
    ..aOB(3, _omitFieldNames ? '' : 'deleted')
    ..aInt64(4, _omitFieldNames ? '' : 'timestamp')
    ..aOS(5, _omitFieldNames ? '' : 'headline')
    ..aOS(6, _omitFieldNames ? '' : 'content')
    ..pPS(7, _omitFieldNames ? '' : 'source')
    ..pPS(8, _omitFieldNames ? '' : 'category')
    ..pPS(9, _omitFieldNames ? '' : 'symbol')
    ..a<$core.String>(10, _omitFieldNames ? '' : 'language', $pb.PbFieldType.OS, defaultOrMaker: 'TR')
    ..pPS(11, _omitFieldNames ? '' : 'attachment')
    ..aOS(12, _omitFieldNames ? '' : 'dailyNewsNo', protoName: 'dailyNewsNo')
    ..aOS(13, _omitFieldNames ? '' : 'chainId', protoName: 'chainId')
    ..pc<RelatedNews>(14, _omitFieldNames ? '' : 'relatedNews', $pb.PbFieldType.PM, protoName: 'relatedNews', subBuilder: RelatedNews.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  NewsMessage clone() => NewsMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  NewsMessage copyWith(void Function(NewsMessage) updates) => super.copyWith((message) => updates(message as NewsMessage)) as NewsMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NewsMessage create() => NewsMessage._();
  NewsMessage createEmptyInstance() => create();
  static $pb.PbList<NewsMessage> createRepeated() => $pb.PbList<NewsMessage>();
  @$core.pragma('dart2js:noInline')
  static NewsMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NewsMessage>(create);
  static NewsMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isFlash => $_getBF(1);
  @$pb.TagNumber(2)
  set isFlash($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIsFlash() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsFlash() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get deleted => $_getBF(2);
  @$pb.TagNumber(3)
  set deleted($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDeleted() => $_has(2);
  @$pb.TagNumber(3)
  void clearDeleted() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get timestamp => $_getI64(3);
  @$pb.TagNumber(4)
  set timestamp($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTimestamp() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimestamp() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get headline => $_getSZ(4);
  @$pb.TagNumber(5)
  set headline($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasHeadline() => $_has(4);
  @$pb.TagNumber(5)
  void clearHeadline() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get content => $_getSZ(5);
  @$pb.TagNumber(6)
  set content($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasContent() => $_has(5);
  @$pb.TagNumber(6)
  void clearContent() => clearField(6);

  @$pb.TagNumber(7)
  $core.List<$core.String> get source => $_getList(6);

  @$pb.TagNumber(8)
  $core.List<$core.String> get category => $_getList(7);

  @$pb.TagNumber(9)
  $core.List<$core.String> get symbol => $_getList(8);

  @$pb.TagNumber(10)
  $core.String get language => $_getS(9, 'TR');
  @$pb.TagNumber(10)
  set language($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasLanguage() => $_has(9);
  @$pb.TagNumber(10)
  void clearLanguage() => clearField(10);

  @$pb.TagNumber(11)
  $core.List<$core.String> get attachment => $_getList(10);

  @$pb.TagNumber(12)
  $core.String get dailyNewsNo => $_getSZ(11);
  @$pb.TagNumber(12)
  set dailyNewsNo($core.String v) { $_setString(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasDailyNewsNo() => $_has(11);
  @$pb.TagNumber(12)
  void clearDailyNewsNo() => clearField(12);

  @$pb.TagNumber(13)
  $core.String get chainId => $_getSZ(12);
  @$pb.TagNumber(13)
  set chainId($core.String v) { $_setString(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasChainId() => $_has(12);
  @$pb.TagNumber(13)
  void clearChainId() => clearField(13);

  @$pb.TagNumber(14)
  $core.List<RelatedNews> get relatedNews => $_getList(13);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
