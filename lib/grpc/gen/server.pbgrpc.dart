//
//  Generated code. Do not modify.
//  source: server.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'server.pb.dart' as $0;

export 'server.pb.dart';

@$pb.GrpcServiceName('Server.Service')
class ServiceClient extends $grpc.Client {
  static final _$anonymousSignUp = $grpc.ClientMethod<$0.AnonymousSignUpRequest, $0.AnonymousSignUpResponse>(
      '/Server.Service/AnonymousSignUp',
      ($0.AnonymousSignUpRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.AnonymousSignUpResponse.fromBuffer(value));
  static final _$createShareGroup = $grpc.ClientMethod<$0.CreateShareGroupRequest, $0.CreateShareGroupResponse>(
      '/Server.Service/CreateShareGroup',
      ($0.CreateShareGroupRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.CreateShareGroupResponse.fromBuffer(value));
  static final _$joinShareGroup = $grpc.ClientMethod<$0.JoinShareGroupRequest, $0.JoinShareGroupResponse>(
      '/Server.Service/JoinShareGroup',
      ($0.JoinShareGroupRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.JoinShareGroupResponse.fromBuffer(value));
  static final _$getCurrentShareGroup = $grpc.ClientMethod<$0.GetCurrentShareGroupRequest, $0.GetCurrentShareGroupResponse>(
      '/Server.Service/GetCurrentShareGroup',
      ($0.GetCurrentShareGroupRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.GetCurrentShareGroupResponse.fromBuffer(value));
  static final _$getShareGroupByLinkKey = $grpc.ClientMethod<$0.GetShareGroupByLinkKeyRequest, $0.GetShareGroupByLinkKeyResponse>(
      '/Server.Service/GetShareGroupByLinkKey',
      ($0.GetShareGroupByLinkKeyRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.GetShareGroupByLinkKeyResponse.fromBuffer(value));
  static final _$updatePosition = $grpc.ClientMethod<$0.UpdatePositionRequest, $0.UpdatePositionResponse>(
      '/Server.Service/UpdatePosition',
      ($0.UpdatePositionRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.UpdatePositionResponse.fromBuffer(value));
  static final _$getCurrentUser = $grpc.ClientMethod<$0.GetCurrentUserRequest, $0.GetCurrentUserResponse>(
      '/Server.Service/GetCurrentUser',
      ($0.GetCurrentUserRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.GetCurrentUserResponse.fromBuffer(value));
  static final _$leaveShareGroup = $grpc.ClientMethod<$0.LeaveShareGroupRequest, $0.LeaveShareGroupResponse>(
      '/Server.Service/LeaveShareGroup',
      ($0.LeaveShareGroupRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.LeaveShareGroupResponse.fromBuffer(value));
  static final _$arriveDest = $grpc.ClientMethod<$0.ArriveDestRequest, $0.ArriveDestResponse>(
      '/Server.Service/ArriveDest',
      ($0.ArriveDestRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ArriveDestResponse.fromBuffer(value));
  static final _$updateShortMessage = $grpc.ClientMethod<$0.UpdateShortMessageRequest, $0.UpdateShortMessageResponse>(
      '/Server.Service/UpdateShortMessage',
      ($0.UpdateShortMessageRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.UpdateShortMessageResponse.fromBuffer(value));
  static final _$getCurrentShareGroupServerStream = $grpc.ClientMethod<$0.GetCurrentShareGroupRequest, $0.GetCurrentShareGroupResponse>(
      '/Server.Service/GetCurrentShareGroupServerStream',
      ($0.GetCurrentShareGroupRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.GetCurrentShareGroupResponse.fromBuffer(value));

  ServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.AnonymousSignUpResponse> anonymousSignUp($0.AnonymousSignUpRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$anonymousSignUp, request, options: options);
  }

  $grpc.ResponseFuture<$0.CreateShareGroupResponse> createShareGroup($0.CreateShareGroupRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createShareGroup, request, options: options);
  }

  $grpc.ResponseFuture<$0.JoinShareGroupResponse> joinShareGroup($0.JoinShareGroupRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$joinShareGroup, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetCurrentShareGroupResponse> getCurrentShareGroup($0.GetCurrentShareGroupRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getCurrentShareGroup, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetShareGroupByLinkKeyResponse> getShareGroupByLinkKey($0.GetShareGroupByLinkKeyRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getShareGroupByLinkKey, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdatePositionResponse> updatePosition($0.UpdatePositionRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updatePosition, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetCurrentUserResponse> getCurrentUser($0.GetCurrentUserRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getCurrentUser, request, options: options);
  }

  $grpc.ResponseFuture<$0.LeaveShareGroupResponse> leaveShareGroup($0.LeaveShareGroupRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$leaveShareGroup, request, options: options);
  }

  $grpc.ResponseFuture<$0.ArriveDestResponse> arriveDest($0.ArriveDestRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$arriveDest, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateShortMessageResponse> updateShortMessage($0.UpdateShortMessageRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateShortMessage, request, options: options);
  }

  $grpc.ResponseStream<$0.GetCurrentShareGroupResponse> getCurrentShareGroupServerStream($0.GetCurrentShareGroupRequest request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$getCurrentShareGroupServerStream, $async.Stream.fromIterable([request]), options: options);
  }
}

@$pb.GrpcServiceName('Server.Service')
abstract class ServiceBase extends $grpc.Service {
  $core.String get $name => 'Server.Service';

  ServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.AnonymousSignUpRequest, $0.AnonymousSignUpResponse>(
        'AnonymousSignUp',
        anonymousSignUp_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.AnonymousSignUpRequest.fromBuffer(value),
        ($0.AnonymousSignUpResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CreateShareGroupRequest, $0.CreateShareGroupResponse>(
        'CreateShareGroup',
        createShareGroup_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CreateShareGroupRequest.fromBuffer(value),
        ($0.CreateShareGroupResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.JoinShareGroupRequest, $0.JoinShareGroupResponse>(
        'JoinShareGroup',
        joinShareGroup_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.JoinShareGroupRequest.fromBuffer(value),
        ($0.JoinShareGroupResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetCurrentShareGroupRequest, $0.GetCurrentShareGroupResponse>(
        'GetCurrentShareGroup',
        getCurrentShareGroup_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetCurrentShareGroupRequest.fromBuffer(value),
        ($0.GetCurrentShareGroupResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetShareGroupByLinkKeyRequest, $0.GetShareGroupByLinkKeyResponse>(
        'GetShareGroupByLinkKey',
        getShareGroupByLinkKey_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetShareGroupByLinkKeyRequest.fromBuffer(value),
        ($0.GetShareGroupByLinkKeyResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdatePositionRequest, $0.UpdatePositionResponse>(
        'UpdatePosition',
        updatePosition_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UpdatePositionRequest.fromBuffer(value),
        ($0.UpdatePositionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetCurrentUserRequest, $0.GetCurrentUserResponse>(
        'GetCurrentUser',
        getCurrentUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetCurrentUserRequest.fromBuffer(value),
        ($0.GetCurrentUserResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LeaveShareGroupRequest, $0.LeaveShareGroupResponse>(
        'LeaveShareGroup',
        leaveShareGroup_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LeaveShareGroupRequest.fromBuffer(value),
        ($0.LeaveShareGroupResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ArriveDestRequest, $0.ArriveDestResponse>(
        'ArriveDest',
        arriveDest_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ArriveDestRequest.fromBuffer(value),
        ($0.ArriveDestResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateShortMessageRequest, $0.UpdateShortMessageResponse>(
        'UpdateShortMessage',
        updateShortMessage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UpdateShortMessageRequest.fromBuffer(value),
        ($0.UpdateShortMessageResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetCurrentShareGroupRequest, $0.GetCurrentShareGroupResponse>(
        'GetCurrentShareGroupServerStream',
        getCurrentShareGroupServerStream_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.GetCurrentShareGroupRequest.fromBuffer(value),
        ($0.GetCurrentShareGroupResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.AnonymousSignUpResponse> anonymousSignUp_Pre($grpc.ServiceCall call, $async.Future<$0.AnonymousSignUpRequest> request) async {
    return anonymousSignUp(call, await request);
  }

  $async.Future<$0.CreateShareGroupResponse> createShareGroup_Pre($grpc.ServiceCall call, $async.Future<$0.CreateShareGroupRequest> request) async {
    return createShareGroup(call, await request);
  }

  $async.Future<$0.JoinShareGroupResponse> joinShareGroup_Pre($grpc.ServiceCall call, $async.Future<$0.JoinShareGroupRequest> request) async {
    return joinShareGroup(call, await request);
  }

  $async.Future<$0.GetCurrentShareGroupResponse> getCurrentShareGroup_Pre($grpc.ServiceCall call, $async.Future<$0.GetCurrentShareGroupRequest> request) async {
    return getCurrentShareGroup(call, await request);
  }

  $async.Future<$0.GetShareGroupByLinkKeyResponse> getShareGroupByLinkKey_Pre($grpc.ServiceCall call, $async.Future<$0.GetShareGroupByLinkKeyRequest> request) async {
    return getShareGroupByLinkKey(call, await request);
  }

  $async.Future<$0.UpdatePositionResponse> updatePosition_Pre($grpc.ServiceCall call, $async.Future<$0.UpdatePositionRequest> request) async {
    return updatePosition(call, await request);
  }

  $async.Future<$0.GetCurrentUserResponse> getCurrentUser_Pre($grpc.ServiceCall call, $async.Future<$0.GetCurrentUserRequest> request) async {
    return getCurrentUser(call, await request);
  }

  $async.Future<$0.LeaveShareGroupResponse> leaveShareGroup_Pre($grpc.ServiceCall call, $async.Future<$0.LeaveShareGroupRequest> request) async {
    return leaveShareGroup(call, await request);
  }

  $async.Future<$0.ArriveDestResponse> arriveDest_Pre($grpc.ServiceCall call, $async.Future<$0.ArriveDestRequest> request) async {
    return arriveDest(call, await request);
  }

  $async.Future<$0.UpdateShortMessageResponse> updateShortMessage_Pre($grpc.ServiceCall call, $async.Future<$0.UpdateShortMessageRequest> request) async {
    return updateShortMessage(call, await request);
  }

  $async.Stream<$0.GetCurrentShareGroupResponse> getCurrentShareGroupServerStream_Pre($grpc.ServiceCall call, $async.Future<$0.GetCurrentShareGroupRequest> request) async* {
    yield* getCurrentShareGroupServerStream(call, await request);
  }

  $async.Future<$0.AnonymousSignUpResponse> anonymousSignUp($grpc.ServiceCall call, $0.AnonymousSignUpRequest request);
  $async.Future<$0.CreateShareGroupResponse> createShareGroup($grpc.ServiceCall call, $0.CreateShareGroupRequest request);
  $async.Future<$0.JoinShareGroupResponse> joinShareGroup($grpc.ServiceCall call, $0.JoinShareGroupRequest request);
  $async.Future<$0.GetCurrentShareGroupResponse> getCurrentShareGroup($grpc.ServiceCall call, $0.GetCurrentShareGroupRequest request);
  $async.Future<$0.GetShareGroupByLinkKeyResponse> getShareGroupByLinkKey($grpc.ServiceCall call, $0.GetShareGroupByLinkKeyRequest request);
  $async.Future<$0.UpdatePositionResponse> updatePosition($grpc.ServiceCall call, $0.UpdatePositionRequest request);
  $async.Future<$0.GetCurrentUserResponse> getCurrentUser($grpc.ServiceCall call, $0.GetCurrentUserRequest request);
  $async.Future<$0.LeaveShareGroupResponse> leaveShareGroup($grpc.ServiceCall call, $0.LeaveShareGroupRequest request);
  $async.Future<$0.ArriveDestResponse> arriveDest($grpc.ServiceCall call, $0.ArriveDestRequest request);
  $async.Future<$0.UpdateShortMessageResponse> updateShortMessage($grpc.ServiceCall call, $0.UpdateShortMessageRequest request);
  $async.Stream<$0.GetCurrentShareGroupResponse> getCurrentShareGroupServerStream($grpc.ServiceCall call, $0.GetCurrentShareGroupRequest request);
}
