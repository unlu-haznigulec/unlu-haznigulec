//
//  Generated code. Do not modify.
//  source: RankedSymbols/RankedSymbols.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use lineDescriptor instead')
const Line$json = {
  '1': 'Line',
  '2': [
    {'1': 'symbol', '3': 1, '4': 2, '5': 9, '10': 'symbol'},
    {'1': 'value', '3': 2, '4': 3, '5': 1, '10': 'value'},
  ],
};

/// Descriptor for `Line`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lineDescriptor = $convert.base64Decode(
    'CgRMaW5lEhYKBnN5bWJvbBgBIAIoCVIGc3ltYm9sEhQKBXZhbHVlGAIgAygBUgV2YWx1ZQ==');

@$core.Deprecated('Use rankedSymbolsMessageDescriptor instead')
const RankedSymbolsMessage$json = {
  '1': 'RankedSymbolsMessage',
  '2': [
    {'1': 'lines', '3': 1, '4': 3, '5': 11, '6': '.messages.Line', '10': 'lines'},
    {'1': 'field', '3': 2, '4': 3, '5': 9, '10': 'field'},
  ],
};

/// Descriptor for `RankedSymbolsMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rankedSymbolsMessageDescriptor = $convert.base64Decode(
    'ChRSYW5rZWRTeW1ib2xzTWVzc2FnZRIkCgVsaW5lcxgBIAMoCzIOLm1lc3NhZ2VzLkxpbmVSBW'
    'xpbmVzEhQKBWZpZWxkGAIgAygJUgVmaWVsZA==');

