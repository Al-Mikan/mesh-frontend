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
    {'1': 'adminUser', '3': 9, '4': 1, '5': 11, '6': '.Server.AdminUser', '10': 'adminUser'},
    {'1': 'isSharingLocation', '3': 10, '4': 1, '5': 8, '10': 'isSharingLocation'},
    {'1': 'sharingLocationStartTime', '3': 11, '4': 1, '5': 9, '9': 0, '10': 'sharingLocationStartTime', '17': true},
  ],
  '8': [
    {'1': '_sharingLocationStartTime'},
  ],
};

/// Descriptor for `ShareGroup`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shareGroupDescriptor = $convert.base64Decode(
    'CgpTaGFyZUdyb3VwEg4KAmlkGAEgASgEUgJpZBIYCgdsaW5rS2V5GAIgASgJUgdsaW5rS2V5Eh'
    'gKB2Rlc3RMb24YAyABKAFSB2Rlc3RMb24SGAoHZGVzdExhdBgEIAEoAVIHZGVzdExhdBIiCgV1'
    'c2VycxgFIAMoCzIMLlNlcnZlci5Vc2VyUgV1c2VycxIgCgttZWV0aW5nVGltZRgGIAEoCVILbW'
    'VldGluZ1RpbWUSHAoJaW52aXRlVXJsGAcgASgJUglpbnZpdGVVcmwSGAoHYWRkcmVzcxgIIAEo'
    'CVIHYWRkcmVzcxIvCglhZG1pblVzZXIYCSABKAsyES5TZXJ2ZXIuQWRtaW5Vc2VyUglhZG1pbl'
    'VzZXISLAoRaXNTaGFyaW5nTG9jYXRpb24YCiABKAhSEWlzU2hhcmluZ0xvY2F0aW9uEj8KGHNo'
    'YXJpbmdMb2NhdGlvblN0YXJ0VGltZRgLIAEoCUgAUhhzaGFyaW5nTG9jYXRpb25TdGFydFRpbW'
    'WIAQFCGwoZX3NoYXJpbmdMb2NhdGlvblN0YXJ0VGltZQ==');

@$core.Deprecated('Use userDescriptor instead')
const User$json = {
  '1': 'User',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'isArrived', '3': 3, '4': 1, '5': 8, '10': 'isArrived'},
    {'1': 'shareGroup', '3': 4, '4': 1, '5': 11, '6': '.Server.ShareGroup', '9': 0, '10': 'shareGroup', '17': true},
    {'1': 'shareGroupId', '3': 5, '4': 1, '5': 4, '9': 1, '10': 'shareGroupId', '17': true},
    {'1': 'lat', '3': 6, '4': 1, '5': 1, '9': 2, '10': 'lat', '17': true},
    {'1': 'lon', '3': 7, '4': 1, '5': 1, '9': 3, '10': 'lon', '17': true},
    {'1': 'positionAt', '3': 8, '4': 1, '5': 9, '9': 4, '10': 'positionAt', '17': true},
    {'1': 'shortMessage', '3': 9, '4': 1, '5': 9, '9': 5, '10': 'shortMessage', '17': true},
    {'1': 'iconID', '3': 10, '4': 1, '5': 9, '10': 'iconID'},
  ],
  '8': [
    {'1': '_shareGroup'},
    {'1': '_shareGroupId'},
    {'1': '_lat'},
    {'1': '_lon'},
    {'1': '_positionAt'},
    {'1': '_shortMessage'},
  ],
};

/// Descriptor for `User`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userDescriptor = $convert.base64Decode(
    'CgRVc2VyEg4KAmlkGAEgASgEUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEhwKCWlzQXJyaXZlZB'
    'gDIAEoCFIJaXNBcnJpdmVkEjcKCnNoYXJlR3JvdXAYBCABKAsyEi5TZXJ2ZXIuU2hhcmVHcm91'
    'cEgAUgpzaGFyZUdyb3VwiAEBEicKDHNoYXJlR3JvdXBJZBgFIAEoBEgBUgxzaGFyZUdyb3VwSW'
    'SIAQESFQoDbGF0GAYgASgBSAJSA2xhdIgBARIVCgNsb24YByABKAFIA1IDbG9uiAEBEiMKCnBv'
    'c2l0aW9uQXQYCCABKAlIBFIKcG9zaXRpb25BdIgBARInCgxzaG9ydE1lc3NhZ2UYCSABKAlIBV'
    'IMc2hvcnRNZXNzYWdliAEBEhYKBmljb25JRBgKIAEoCVIGaWNvbklEQg0KC19zaGFyZUdyb3Vw'
    'Qg8KDV9zaGFyZUdyb3VwSWRCBgoEX2xhdEIGCgRfbG9uQg0KC19wb3NpdGlvbkF0Qg8KDV9zaG'
    '9ydE1lc3NhZ2U=');

@$core.Deprecated('Use adminUserDescriptor instead')
const AdminUser$json = {
  '1': 'AdminUser',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `AdminUser`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List adminUserDescriptor = $convert.base64Decode(
    'CglBZG1pblVzZXISDgoCaWQYASABKARSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWU=');

@$core.Deprecated('Use anonymousSignUpRequestDescriptor instead')
const AnonymousSignUpRequest$json = {
  '1': 'AnonymousSignUpRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'iconID', '3': 2, '4': 1, '5': 9, '10': 'iconID'},
  ],
};

/// Descriptor for `AnonymousSignUpRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List anonymousSignUpRequestDescriptor = $convert.base64Decode(
    'ChZBbm9ueW1vdXNTaWduVXBSZXF1ZXN0EhIKBG5hbWUYASABKAlSBG5hbWUSFgoGaWNvbklEGA'
    'IgASgJUgZpY29uSUQ=');

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
    {'1': 'sharingLocationStartTime', '3': 5, '4': 1, '5': 9, '9': 0, '10': 'sharingLocationStartTime', '17': true},
  ],
  '8': [
    {'1': '_sharingLocationStartTime'},
  ],
};

/// Descriptor for `CreateShareGroupRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createShareGroupRequestDescriptor = $convert.base64Decode(
    'ChdDcmVhdGVTaGFyZUdyb3VwUmVxdWVzdBIYCgdkZXN0TG9uGAEgASgBUgdkZXN0TG9uEhgKB2'
    'Rlc3RMYXQYAiABKAFSB2Rlc3RMYXQSIAoLbWVldGluZ1RpbWUYAyABKAlSC21lZXRpbmdUaW1l'
    'EhgKB2FkZHJlc3MYBCABKAlSB2FkZHJlc3MSPwoYc2hhcmluZ0xvY2F0aW9uU3RhcnRUaW1lGA'
    'UgASgJSABSGHNoYXJpbmdMb2NhdGlvblN0YXJ0VGltZYgBAUIbChlfc2hhcmluZ0xvY2F0aW9u'
    'U3RhcnRUaW1l');

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
};

/// Descriptor for `LeaveShareGroupResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List leaveShareGroupResponseDescriptor = $convert.base64Decode(
    'ChdMZWF2ZVNoYXJlR3JvdXBSZXNwb25zZQ==');

@$core.Deprecated('Use arriveDestRequestDescriptor instead')
const ArriveDestRequest$json = {
  '1': 'ArriveDestRequest',
};

/// Descriptor for `ArriveDestRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List arriveDestRequestDescriptor = $convert.base64Decode(
    'ChFBcnJpdmVEZXN0UmVxdWVzdA==');

@$core.Deprecated('Use arriveDestResponseDescriptor instead')
const ArriveDestResponse$json = {
  '1': 'ArriveDestResponse',
  '2': [
    {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.Server.User', '10': 'user'},
  ],
};

/// Descriptor for `ArriveDestResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List arriveDestResponseDescriptor = $convert.base64Decode(
    'ChJBcnJpdmVEZXN0UmVzcG9uc2USIAoEdXNlchgBIAEoCzIMLlNlcnZlci5Vc2VyUgR1c2Vy');

@$core.Deprecated('Use updateShortMessageRequestDescriptor instead')
const UpdateShortMessageRequest$json = {
  '1': 'UpdateShortMessageRequest',
  '2': [
    {'1': 'shortMessage', '3': 1, '4': 1, '5': 9, '10': 'shortMessage'},
  ],
};

/// Descriptor for `UpdateShortMessageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateShortMessageRequestDescriptor = $convert.base64Decode(
    'ChlVcGRhdGVTaG9ydE1lc3NhZ2VSZXF1ZXN0EiIKDHNob3J0TWVzc2FnZRgBIAEoCVIMc2hvcn'
    'RNZXNzYWdl');

@$core.Deprecated('Use updateShortMessageResponseDescriptor instead')
const UpdateShortMessageResponse$json = {
  '1': 'UpdateShortMessageResponse',
  '2': [
    {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.Server.User', '10': 'user'},
  ],
};

/// Descriptor for `UpdateShortMessageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateShortMessageResponseDescriptor = $convert.base64Decode(
    'ChpVcGRhdGVTaG9ydE1lc3NhZ2VSZXNwb25zZRIgCgR1c2VyGAEgASgLMgwuU2VydmVyLlVzZX'
    'JSBHVzZXI=');

