//
//  Generated code. Do not modify.
//  source: Timestamp/Timestamp.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use timeMessageDescriptor instead')
const TimeMessage$json = {
  '1': 'TimeMessage',
  '2': [
    {'1': 'timestamp', '3': 1, '4': 1, '5': 3, '10': 'timestamp'},
    {'1': 'source', '3': 2, '4': 1, '5': 9, '10': 'source'},
    {'1': 'isBistPPHoliday', '3': 3, '4': 1, '5': 8, '10': 'isBistPPHoliday'},
    {'1': 'isBistPPOpen', '3': 4, '4': 1, '5': 8, '10': 'isBistPPOpen'},
  ],
};

/// Descriptor for `TimeMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List timeMessageDescriptor = $convert.base64Decode(
    'CgtUaW1lTWVzc2FnZRIcCgl0aW1lc3RhbXAYASABKANSCXRpbWVzdGFtcBIWCgZzb3VyY2UYAi'
    'ABKAlSBnNvdXJjZRIoCg9pc0Jpc3RQUEhvbGlkYXkYAyABKAhSD2lzQmlzdFBQSG9saWRheRIi'
    'Cgxpc0Jpc3RQUE9wZW4YBCABKAhSDGlzQmlzdFBQT3Blbg==');

