//
//  Generated code. Do not modify.
//  source: DepthStats/DepthStats.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use depthStatsMessageDescriptor instead')
const DepthStatsMessage$json = {
  '1': 'DepthStatsMessage',
  '2': [
    {'1': 'timestamp', '3': 1, '4': 1, '5': 3, '10': 'timestamp'},
    {'1': 'totalBidWAvg', '3': 2, '4': 1, '5': 1, '10': 'totalBidWAvg'},
    {'1': 'totalAskWAvg', '3': 3, '4': 1, '5': 1, '10': 'totalAskWAvg'},
    {'1': 'totalBidQuantity', '3': 4, '4': 1, '5': 1, '10': 'totalBidQuantity'},
    {'1': 'totalAskQuantity', '3': 5, '4': 1, '5': 1, '10': 'totalAskQuantity'},
  ],
};

/// Descriptor for `DepthStatsMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List depthStatsMessageDescriptor = $convert.base64Decode(
    'ChFEZXB0aFN0YXRzTWVzc2FnZRIcCgl0aW1lc3RhbXAYASABKANSCXRpbWVzdGFtcBIiCgx0b3'
    'RhbEJpZFdBdmcYAiABKAFSDHRvdGFsQmlkV0F2ZxIiCgx0b3RhbEFza1dBdmcYAyABKAFSDHRv'
    'dGFsQXNrV0F2ZxIqChB0b3RhbEJpZFF1YW50aXR5GAQgASgBUhB0b3RhbEJpZFF1YW50aXR5Ei'
    'oKEHRvdGFsQXNrUXVhbnRpdHkYBSABKAFSEHRvdGFsQXNrUXVhbnRpdHk=');

