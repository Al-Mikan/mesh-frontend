//
//  Generated code. Do not modify.
//  source: server.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use shareGroupDescriptor instead')
const ShareGroup$json = {
  '1': 'ShareGroup',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'linkKey', '3': 2, '4': 1, '5': 9, '10': 'linkKey'},
    {'1': 'destLon', '3': 3, '4': 1, '5': 1, '10': 'destLon'},
    {'1': 'destLat', '3': 4, '4': 1, '5': 1, '10': 'destLat'},
    {'1': 'users', '3': 5, '4': 3, '5': 11, '6': '.Server.User', '10': 'users'},
    {'1': 'meetingTime', '3': 6, '4': 1, '5': 9, '10': 'meetingTime'},
    {'1': 'inviteUrl', '3': 7, '4': 1, '5': 9, '10': 'inviteUrl'},
    {'1': 'address', '3': 8, '4': 1, '5': 9, '10': 'address'},
    {'1': 'adminUser', '3': 9, '4': 1, '5': 11, '6': '.Server.User', '10': 'adminUser'},
  ],
};

/// Descriptor for `ShareGroup`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shareGroupDescriptor = $convert.base64Decode(
    'CgpTaGFyZUdyb3VwEg4KAmlkGAEgASgEUgJpZBIYCgdsaW5rS2V5GAIgASgJUgdsaW5rS2V5Eh'
    'gKB2Rlc3RMb24YAyABKAFSB2Rlc3RMb24SGAoHZGVzdExhdBgEIAEoAVIHZGVzdExhdBIiCgV1'
    'c2VycxgFIAMoCzIMLlNlcnZlci5Vc2VyUgV1c2VycxIgCgttZWV0aW5nVGltZRgGIAEoCVILbW'
    'VldGluZ1RpbWUSHAoJaW52aXRlVXJsGAcgASgJUglpbnZpdGVVcmwSGAoHYWRkcmVzcxgIIAEo'
    'CVIHYWRkcmVzcxIqCglhZG1pblVzZXIYCSABKAsyDC5TZXJ2ZXIuVXNlclIJYWRtaW5Vc2Vy');

@$core.Deprecated('Use userDescriptor instead')
const User$json = {
  '1': 'User',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'shareGroup', '3': 3, '4': 1, '5': 11, '6': '.Server.ShareGroup', '10': 'shareGroup'},
    {'1': 'shareGroupId', '3': 4, '4': 1, '5': 4, '10': 'shareGroupId'},
    {'1': 'lat', '3': 5, '4': 1, '5': 1, '10': 'lat'},
    {'1': 'lon', '3': 6, '4': 1, '5': 1, '10': 'lon'},
    {'1': 'positionAt', '3': 7, '4': 1, '5': 9, '10': 'positionAt'},
  ],
};

/// Descriptor for `User`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userDescriptor = $convert.base64Decode(
    'CgRVc2VyEg4KAmlkGAEgASgEUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEjIKCnNoYXJlR3JvdX'
    'AYAyABKAsyEi5TZXJ2ZXIuU2hhcmVHcm91cFIKc2hhcmVHcm91cBIiCgxzaGFyZUdyb3VwSWQY'
    'BCABKARSDHNoYXJlR3JvdXBJZBIQCgNsYXQYBSABKAFSA2xhdBIQCgNsb24YBiABKAFSA2xvbh'
    'IeCgpwb3NpdGlvbkF0GAcgASgJUgpwb3NpdGlvbkF0');

@$core.Deprecated('Use anonymousSignUpRequestDescriptor instead')
const AnonymousSignUpRequest$json = {
  '1': 'AnonymousSignUpRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `AnonymousSignUpRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List anonymousSignUpRequestDescriptor = $convert.base64Decode(
    'ChZBbm9ueW1vdXNTaWduVXBSZXF1ZXN0EhIKBG5hbWUYASABKAlSBG5hbWU=');

@$core.Deprecated('Use anonymousSignUpResponseDescriptor instead')
const AnonymousSignUpResponse$json = {
  '1': 'AnonymousSignUpResponse',
  '2': [
    {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.Server.User', '10': 'user'},
    {'1': 'accessToken', '3': 2, '4': 1, '5': 9, '10': 'accessToken'},
  ],
};

/// Descriptor for `AnonymousSignUpResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List anonymousSignUpResponseDescriptor = $convert.base64Decode(
    'ChdBbm9ueW1vdXNTaWduVXBSZXNwb25zZRIgCgR1c2VyGAEgASgLMgwuU2VydmVyLlVzZXJSBH'
    'VzZXISIAoLYWNjZXNzVG9rZW4YAiABKAlSC2FjY2Vzc1Rva2Vu');

@$core.Deprecated('Use createShareGroupRequestDescriptor instead')
const CreateShareGroupRequest$json = {
  '1': 'CreateShareGroupRequest',
  '2': [
    {'1': 'destLon', '3': 1, '4': 1, '5': 1, '10': 'destLon'},
    {'1': 'destLat', '3': 2, '4': 1, '5': 1, '10': 'destLat'},
    {'1': 'meetingTime', '3': 3, '4': 1, '5': 9, '10': 'meetingTime'},
    {'1': 'address', '3': 4, '4': 1, '5': 9, '10': 'address'},
  ],
};

/// Descriptor for `CreateShareGroupRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createShareGroupRequestDescriptor = $convert.base64Decode(
    'ChdDcmVhdGVTaGFyZUdyb3VwUmVxdWVzdBIYCgdkZXN0TG9uGAEgASgBUgdkZXN0TG9uEhgKB2'
    'Rlc3RMYXQYAiABKAFSB2Rlc3RMYXQSIAoLbWVldGluZ1RpbWUYAyABKAlSC21lZXRpbmdUaW1l'
    'EhgKB2FkZHJlc3MYBCABKAlSB2FkZHJlc3M=');

@$core.Deprecated('Use createShareGroupResponseDescriptor instead')
const CreateShareGroupResponse$json = {
  '1': 'CreateShareGroupResponse',
  '2': [
    {'1': 'shareGroup', '3': 1, '4': 1, '5': 11, '6': '.Server.ShareGroup', '10': 'shareGroup'},
  ],
};

/// Descriptor for `CreateShareGroupResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createShareGroupResponseDescriptor = $convert.base64Decode(
    'ChhDcmVhdGVTaGFyZUdyb3VwUmVzcG9uc2USMgoKc2hhcmVHcm91cBgBIAEoCzISLlNlcnZlci'
    '5TaGFyZUdyb3VwUgpzaGFyZUdyb3Vw');

@$core.Deprecated('Use joinShareGroupRequestDescriptor instead')
const JoinShareGroupRequest$json = {
  '1': 'JoinShareGroupRequest',
  '2': [
    {'1': 'linkKey', '3': 1, '4': 1, '5': 9, '10': 'linkKey'},
  ],
};

/// Descriptor for `JoinShareGroupRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinShareGroupRequestDescriptor = $convert.base64Decode(
    'ChVKb2luU2hhcmVHcm91cFJlcXVlc3QSGAoHbGlua0tleRgBIAEoCVIHbGlua0tleQ==');

@$core.Deprecated('Use joinShareGroupResponseDescriptor instead')
const JoinShareGroupResponse$json = {
  '1': 'JoinShareGroupResponse',
  '2': [
    {'1': 'shareGroup', '3': 1, '4': 1, '5': 11, '6': '.Server.ShareGroup', '10': 'shareGroup'},
  ],
};

/// Descriptor for `JoinShareGroupResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinShareGroupResponseDescriptor = $convert.base64Decode(
    'ChZKb2luU2hhcmVHcm91cFJlc3BvbnNlEjIKCnNoYXJlR3JvdXAYASABKAsyEi5TZXJ2ZXIuU2'
    'hhcmVHcm91cFIKc2hhcmVHcm91cA==');

@$core.Deprecated('Use getShareGroupByLinkKeyRequestDescriptor instead')
const GetShareGroupByLinkKeyRequest$json = {
  '1': 'GetShareGroupByLinkKeyRequest',
  '2': [
    {'1': 'linkKey', '3': 1, '4': 1, '5': 9, '10': 'linkKey'},
  ],
};

/// Descriptor for `GetShareGroupByLinkKeyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getShareGroupByLinkKeyRequestDescriptor = $convert.base64Decode(
    'Ch1HZXRTaGFyZUdyb3VwQnlMaW5rS2V5UmVxdWVzdBIYCgdsaW5rS2V5GAEgASgJUgdsaW5rS2'
    'V5');

@$core.Deprecated('Use getShareGroupByLinkKeyResponseDescriptor instead')
const GetShareGroupByLinkKeyResponse$json = {
  '1': 'GetShareGroupByLinkKeyResponse',
  '2': [
    {'1': 'shareGroup', '3': 1, '4': 1, '5': 11, '6': '.Server.ShareGroup', '10': 'shareGroup'},
  ],
};

/// Descriptor for `GetShareGroupByLinkKeyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getShareGroupByLinkKeyResponseDescriptor = $convert.base64Decode(
    'Ch5HZXRTaGFyZUdyb3VwQnlMaW5rS2V5UmVzcG9uc2USMgoKc2hhcmVHcm91cBgBIAEoCzISLl'
    'NlcnZlci5TaGFyZUdyb3VwUgpzaGFyZUdyb3Vw');

@$core.Deprecated('Use getCurrentShareGroupRequestDescriptor instead')
const GetCurrentShareGroupRequest$json = {
  '1': 'GetCurrentShareGroupRequest',
};

/// Descriptor for `GetCurrentShareGroupRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCurrentShareGroupRequestDescriptor = $convert.base64Decode(
    'ChtHZXRDdXJyZW50U2hhcmVHcm91cFJlcXVlc3Q=');

@$core.Deprecated('Use getCurrentShareGroupResponseDescriptor instead')
const GetCurrentShareGroupResponse$json = {
  '1': 'GetCurrentShareGroupResponse',
  '2': [
    {'1': 'shareGroup', '3': 1, '4': 1, '5': 11, '6': '.Server.ShareGroup', '10': 'shareGroup'},
  ],
};

/// Descriptor for `GetCurrentShareGroupResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCurrentShareGroupResponseDescriptor = $convert.base64Decode(
    'ChxHZXRDdXJyZW50U2hhcmVHcm91cFJlc3BvbnNlEjIKCnNoYXJlR3JvdXAYASABKAsyEi5TZX'
    'J2ZXIuU2hhcmVHcm91cFIKc2hhcmVHcm91cA==');

@$core.Deprecated('Use updatePositionRequestDescriptor instead')
const UpdatePositionRequest$json = {
  '1': 'UpdatePositionRequest',
  '2': [
    {'1': 'lat', '3': 1, '4': 1, '5': 1, '10': 'lat'},
    {'1': 'lon', '3': 2, '4': 1, '5': 1, '10': 'lon'},
  ],
};

/// Descriptor for `UpdatePositionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updatePositionRequestDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVQb3NpdGlvblJlcXVlc3QSEAoDbGF0GAEgASgBUgNsYXQSEAoDbG9uGAIgASgBUg'
    'Nsb24=');

@$core.Deprecated('Use updatePositionResponseDescriptor instead')
const UpdatePositionResponse$json = {
  '1': 'UpdatePositionResponse',
  '2': [
    {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.Server.User', '10': 'user'},
  ],
};

/// Descriptor for `UpdatePositionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updatePositionResponseDescriptor = $convert.base64Decode(
    'ChZVcGRhdGVQb3NpdGlvblJlc3BvbnNlEiAKBHVzZXIYASABKAsyDC5TZXJ2ZXIuVXNlclIEdX'
    'Nlcg==');

@$core.Deprecated('Use getCurrentUserRequestDescriptor instead')
const GetCurrentUserRequest$json = {
  '1': 'GetCurrentUserRequest',
};

/// Descriptor for `GetCurrentUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCurrentUserRequestDescriptor = $convert.base64Decode(
    'ChVHZXRDdXJyZW50VXNlclJlcXVlc3Q=');

@$core.Deprecated('Use getCurrentUserResponseDescriptor instead')
const GetCurrentUserResponse$json = {
  '1': 'GetCurrentUserResponse',
  '2': [
    {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.Server.User', '10': 'user'},
  ],
};

/// Descriptor for `GetCurrentUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCurrentUserResponseDescriptor = $convert.base64Decode(
    'ChZHZXRDdXJyZW50VXNlclJlc3BvbnNlEiAKBHVzZXIYASABKAsyDC5TZXJ2ZXIuVXNlclIEdX'
    'Nlcg==');

@$core.Deprecated('Use leaveShareGroupRequestDescriptor instead')
const LeaveShareGroupRequest$json = {
  '1': 'LeaveShareGroupRequest',
};

/// Descriptor for `LeaveShareGroupRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List leaveShareGroupRequestDescriptor = $convert.base64Decode(
    'ChZMZWF2ZVNoYXJlR3JvdXBSZXF1ZXN0');

@$core.Deprecated('Use leaveShareGroupResponseDescriptor instead')
const LeaveShareGroupResponse$json = {
  '1': 'LeaveShareGroupResponse',
  '2': [
    {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.Server.User', '10': 'user'},
  ],
};

/// Descriptor for `LeaveShareGroupResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List leaveShareGroupResponseDescriptor = $convert.base64Decode(
    'ChdMZWF2ZVNoYXJlR3JvdXBSZXNwb25zZRIgCgR1c2VyGAEgASgLMgwuU2VydmVyLlVzZXJSBH'
    'VzZXI=');

