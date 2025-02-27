//
//  Generated code. Do not modify.
//  source: server.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class ShareGroup extends $pb.GeneratedMessage {
  factory ShareGroup({
    $fixnum.Int64? id,
    $core.String? linkKey,
    $core.double? destLon,
    $core.double? destLat,
    $core.Iterable<User>? users,
    $core.String? meetingTime,
    $core.String? inviteUrl,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (linkKey != null) {
      $result.linkKey = linkKey;
    }
    if (destLon != null) {
      $result.destLon = destLon;
    }
    if (destLat != null) {
      $result.destLat = destLat;
    }
    if (users != null) {
      $result.users.addAll(users);
    }
    if (meetingTime != null) {
      $result.meetingTime = meetingTime;
    }
    if (inviteUrl != null) {
      $result.inviteUrl = inviteUrl;
    }
    return $result;
  }
  ShareGroup._() : super();
  factory ShareGroup.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ShareGroup.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ShareGroup', package: const $pb.PackageName(_omitMessageNames ? '' : 'Server'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'linkKey', protoName: 'linkKey')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'destLon', $pb.PbFieldType.OD, protoName: 'destLon')
    ..a<$core.double>(4, _omitFieldNames ? '' : 'destLat', $pb.PbFieldType.OD, protoName: 'destLat')
    ..pc<User>(5, _omitFieldNames ? '' : 'users', $pb.PbFieldType.PM, subBuilder: User.create)
    ..aOS(6, _omitFieldNames ? '' : 'meetingTime', protoName: 'meetingTime')
    ..aOS(7, _omitFieldNames ? '' : 'inviteUrl', protoName: 'inviteUrl')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ShareGroup clone() => ShareGroup()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ShareGroup copyWith(void Function(ShareGroup) updates) => super.copyWith((message) => updates(message as ShareGroup)) as ShareGroup;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ShareGroup create() => ShareGroup._();
  ShareGroup createEmptyInstance() => create();
  static $pb.PbList<ShareGroup> createRepeated() => $pb.PbList<ShareGroup>();
  @$core.pragma('dart2js:noInline')
  static ShareGroup getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ShareGroup>(create);
  static ShareGroup? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get linkKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set linkKey($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLinkKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearLinkKey() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get destLon => $_getN(2);
  @$pb.TagNumber(3)
  set destLon($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDestLon() => $_has(2);
  @$pb.TagNumber(3)
  void clearDestLon() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get destLat => $_getN(3);
  @$pb.TagNumber(4)
  set destLat($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDestLat() => $_has(3);
  @$pb.TagNumber(4)
  void clearDestLat() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<User> get users => $_getList(4);

  @$pb.TagNumber(6)
  $core.String get meetingTime => $_getSZ(5);
  @$pb.TagNumber(6)
  set meetingTime($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasMeetingTime() => $_has(5);
  @$pb.TagNumber(6)
  void clearMeetingTime() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get inviteUrl => $_getSZ(6);
  @$pb.TagNumber(7)
  set inviteUrl($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasInviteUrl() => $_has(6);
  @$pb.TagNumber(7)
  void clearInviteUrl() => clearField(7);
}

class User extends $pb.GeneratedMessage {
  factory User({
    $fixnum.Int64? id,
    $core.String? name,
    ShareGroup? shareGroup,
    $fixnum.Int64? shareGroupId,
    $core.double? lat,
    $core.double? lon,
    $core.String? positionAt,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (name != null) {
      $result.name = name;
    }
    if (shareGroup != null) {
      $result.shareGroup = shareGroup;
    }
    if (shareGroupId != null) {
      $result.shareGroupId = shareGroupId;
    }
    if (lat != null) {
      $result.lat = lat;
    }
    if (lon != null) {
      $result.lon = lon;
    }
    if (positionAt != null) {
      $result.positionAt = positionAt;
    }
    return $result;
  }
  User._() : super();
  factory User.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory User.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'User', package: const $pb.PackageName(_omitMessageNames ? '' : 'Server'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOM<ShareGroup>(3, _omitFieldNames ? '' : 'shareGroup', protoName: 'shareGroup', subBuilder: ShareGroup.create)
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'shareGroupId', $pb.PbFieldType.OU6, protoName: 'shareGroupId', defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'lat', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'lon', $pb.PbFieldType.OD)
    ..aOS(7, _omitFieldNames ? '' : 'positionAt', protoName: 'positionAt')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  User clone() => User()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  User copyWith(void Function(User) updates) => super.copyWith((message) => updates(message as User)) as User;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static User create() => User._();
  User createEmptyInstance() => create();
  static $pb.PbList<User> createRepeated() => $pb.PbList<User>();
  @$core.pragma('dart2js:noInline')
  static User getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<User>(create);
  static User? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  ShareGroup get shareGroup => $_getN(2);
  @$pb.TagNumber(3)
  set shareGroup(ShareGroup v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasShareGroup() => $_has(2);
  @$pb.TagNumber(3)
  void clearShareGroup() => clearField(3);
  @$pb.TagNumber(3)
  ShareGroup ensureShareGroup() => $_ensure(2);

  @$pb.TagNumber(4)
  $fixnum.Int64 get shareGroupId => $_getI64(3);
  @$pb.TagNumber(4)
  set shareGroupId($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasShareGroupId() => $_has(3);
  @$pb.TagNumber(4)
  void clearShareGroupId() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get lat => $_getN(4);
  @$pb.TagNumber(5)
  set lat($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasLat() => $_has(4);
  @$pb.TagNumber(5)
  void clearLat() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get lon => $_getN(5);
  @$pb.TagNumber(6)
  set lon($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasLon() => $_has(5);
  @$pb.TagNumber(6)
  void clearLon() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get positionAt => $_getSZ(6);
  @$pb.TagNumber(7)
  set positionAt($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasPositionAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearPositionAt() => clearField(7);
}

class AnonymousSignUpRequest extends $pb.GeneratedMessage {
  factory AnonymousSignUpRequest({
    $core.String? name,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    return $result;
  }
  AnonymousSignUpRequest._() : super();
  factory AnonymousSignUpRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AnonymousSignUpRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AnonymousSignUpRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'Server'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AnonymousSignUpRequest clone() => AnonymousSignUpRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AnonymousSignUpRequest copyWith(void Function(AnonymousSignUpRequest) updates) => super.copyWith((message) => updates(message as AnonymousSignUpRequest)) as AnonymousSignUpRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AnonymousSignUpRequest create() => AnonymousSignUpRequest._();
  AnonymousSignUpRequest createEmptyInstance() => create();
  static $pb.PbList<AnonymousSignUpRequest> createRepeated() => $pb.PbList<AnonymousSignUpRequest>();
  @$core.pragma('dart2js:noInline')
  static AnonymousSignUpRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AnonymousSignUpRequest>(create);
  static AnonymousSignUpRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);
}

class AnonymousSignUpResponse extends $pb.GeneratedMessage {
  factory AnonymousSignUpResponse({
    User? user,
    $core.String? accessToken,
  }) {
    final $result = create();
    if (user != null) {
      $result.user = user;
    }
    if (accessToken != null) {
      $result.accessToken = accessToken;
    }
    return $result;
  }
  AnonymousSignUpResponse._() : super();
  factory AnonymousSignUpResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AnonymousSignUpResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AnonymousSignUpResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'Server'), createEmptyInstance: create)
    ..aOM<User>(1, _omitFieldNames ? '' : 'user', subBuilder: User.create)
    ..aOS(2, _omitFieldNames ? '' : 'accessToken', protoName: 'accessToken')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AnonymousSignUpResponse clone() => AnonymousSignUpResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AnonymousSignUpResponse copyWith(void Function(AnonymousSignUpResponse) updates) => super.copyWith((message) => updates(message as AnonymousSignUpResponse)) as AnonymousSignUpResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AnonymousSignUpResponse create() => AnonymousSignUpResponse._();
  AnonymousSignUpResponse createEmptyInstance() => create();
  static $pb.PbList<AnonymousSignUpResponse> createRepeated() => $pb.PbList<AnonymousSignUpResponse>();
  @$core.pragma('dart2js:noInline')
  static AnonymousSignUpResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AnonymousSignUpResponse>(create);
  static AnonymousSignUpResponse? _defaultInstance;

  @$pb.TagNumber(1)
  User get user => $_getN(0);
  @$pb.TagNumber(1)
  set user(User v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => clearField(1);
  @$pb.TagNumber(1)
  User ensureUser() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get accessToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set accessToken($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAccessToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccessToken() => clearField(2);
}

class CreateShareGroupRequest extends $pb.GeneratedMessage {
  factory CreateShareGroupRequest({
    $core.double? destLon,
    $core.double? destLat,
    $core.String? meetingTime,
  }) {
    final $result = create();
    if (destLon != null) {
      $result.destLon = destLon;
    }
    if (destLat != null) {
      $result.destLat = destLat;
    }
    if (meetingTime != null) {
      $result.meetingTime = meetingTime;
    }
    return $result;
  }
  CreateShareGroupRequest._() : super();
  factory CreateShareGroupRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateShareGroupRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateShareGroupRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'Server'), createEmptyInstance: create)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'destLon', $pb.PbFieldType.OD, protoName: 'destLon')
    ..a<$core.double>(4, _omitFieldNames ? '' : 'destLat', $pb.PbFieldType.OD, protoName: 'destLat')
    ..aOS(5, _omitFieldNames ? '' : 'meetingTime', protoName: 'meetingTime')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateShareGroupRequest clone() => CreateShareGroupRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateShareGroupRequest copyWith(void Function(CreateShareGroupRequest) updates) => super.copyWith((message) => updates(message as CreateShareGroupRequest)) as CreateShareGroupRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateShareGroupRequest create() => CreateShareGroupRequest._();
  CreateShareGroupRequest createEmptyInstance() => create();
  static $pb.PbList<CreateShareGroupRequest> createRepeated() => $pb.PbList<CreateShareGroupRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateShareGroupRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateShareGroupRequest>(create);
  static CreateShareGroupRequest? _defaultInstance;

  @$pb.TagNumber(3)
  $core.double get destLon => $_getN(0);
  @$pb.TagNumber(3)
  set destLon($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(3)
  $core.bool hasDestLon() => $_has(0);
  @$pb.TagNumber(3)
  void clearDestLon() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get destLat => $_getN(1);
  @$pb.TagNumber(4)
  set destLat($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(4)
  $core.bool hasDestLat() => $_has(1);
  @$pb.TagNumber(4)
  void clearDestLat() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get meetingTime => $_getSZ(2);
  @$pb.TagNumber(5)
  set meetingTime($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(5)
  $core.bool hasMeetingTime() => $_has(2);
  @$pb.TagNumber(5)
  void clearMeetingTime() => clearField(5);
}

class CreateShareGroupResponse extends $pb.GeneratedMessage {
  factory CreateShareGroupResponse({
    ShareGroup? shareGroup,
  }) {
    final $result = create();
    if (shareGroup != null) {
      $result.shareGroup = shareGroup;
    }
    return $result;
  }
  CreateShareGroupResponse._() : super();
  factory CreateShareGroupResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateShareGroupResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateShareGroupResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'Server'), createEmptyInstance: create)
    ..aOM<ShareGroup>(1, _omitFieldNames ? '' : 'shareGroup', protoName: 'shareGroup', subBuilder: ShareGroup.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateShareGroupResponse clone() => CreateShareGroupResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateShareGroupResponse copyWith(void Function(CreateShareGroupResponse) updates) => super.copyWith((message) => updates(message as CreateShareGroupResponse)) as CreateShareGroupResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateShareGroupResponse create() => CreateShareGroupResponse._();
  CreateShareGroupResponse createEmptyInstance() => create();
  static $pb.PbList<CreateShareGroupResponse> createRepeated() => $pb.PbList<CreateShareGroupResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateShareGroupResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateShareGroupResponse>(create);
  static CreateShareGroupResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ShareGroup get shareGroup => $_getN(0);
  @$pb.TagNumber(1)
  set shareGroup(ShareGroup v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasShareGroup() => $_has(0);
  @$pb.TagNumber(1)
  void clearShareGroup() => clearField(1);
  @$pb.TagNumber(1)
  ShareGroup ensureShareGroup() => $_ensure(0);
}

class JoinShareGroupRequest extends $pb.GeneratedMessage {
  factory JoinShareGroupRequest({
    $core.String? linkKey,
  }) {
    final $result = create();
    if (linkKey != null) {
      $result.linkKey = linkKey;
    }
    return $result;
  }
  JoinShareGroupRequest._() : super();
  factory JoinShareGroupRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory JoinShareGroupRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'JoinShareGroupRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'Server'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'linkKey', protoName: 'linkKey')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  JoinShareGroupRequest clone() => JoinShareGroupRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  JoinShareGroupRequest copyWith(void Function(JoinShareGroupRequest) updates) => super.copyWith((message) => updates(message as JoinShareGroupRequest)) as JoinShareGroupRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JoinShareGroupRequest create() => JoinShareGroupRequest._();
  JoinShareGroupRequest createEmptyInstance() => create();
  static $pb.PbList<JoinShareGroupRequest> createRepeated() => $pb.PbList<JoinShareGroupRequest>();
  @$core.pragma('dart2js:noInline')
  static JoinShareGroupRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<JoinShareGroupRequest>(create);
  static JoinShareGroupRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get linkKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set linkKey($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLinkKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearLinkKey() => clearField(1);
}

class JoinShareGroupResponse extends $pb.GeneratedMessage {
  factory JoinShareGroupResponse({
    ShareGroup? shareGroup,
  }) {
    final $result = create();
    if (shareGroup != null) {
      $result.shareGroup = shareGroup;
    }
    return $result;
  }
  JoinShareGroupResponse._() : super();
  factory JoinShareGroupResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory JoinShareGroupResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'JoinShareGroupResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'Server'), createEmptyInstance: create)
    ..aOM<ShareGroup>(1, _omitFieldNames ? '' : 'shareGroup', protoName: 'shareGroup', subBuilder: ShareGroup.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  JoinShareGroupResponse clone() => JoinShareGroupResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  JoinShareGroupResponse copyWith(void Function(JoinShareGroupResponse) updates) => super.copyWith((message) => updates(message as JoinShareGroupResponse)) as JoinShareGroupResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JoinShareGroupResponse create() => JoinShareGroupResponse._();
  JoinShareGroupResponse createEmptyInstance() => create();
  static $pb.PbList<JoinShareGroupResponse> createRepeated() => $pb.PbList<JoinShareGroupResponse>();
  @$core.pragma('dart2js:noInline')
  static JoinShareGroupResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<JoinShareGroupResponse>(create);
  static JoinShareGroupResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ShareGroup get shareGroup => $_getN(0);
  @$pb.TagNumber(1)
  set shareGroup(ShareGroup v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasShareGroup() => $_has(0);
  @$pb.TagNumber(1)
  void clearShareGroup() => clearField(1);
  @$pb.TagNumber(1)
  ShareGroup ensureShareGroup() => $_ensure(0);
}

class GetCurrentShareGroupRequest extends $pb.GeneratedMessage {
  factory GetCurrentShareGroupRequest({
    $core.String? groupId,
  }) {
    final $result = create();
    if (groupId != null) {
      $result.groupId = groupId;
    }
    return $result;
  }
  GetCurrentShareGroupRequest._() : super();
  factory GetCurrentShareGroupRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetCurrentShareGroupRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetCurrentShareGroupRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'Server'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'groupId', protoName: 'groupId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetCurrentShareGroupRequest clone() => GetCurrentShareGroupRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetCurrentShareGroupRequest copyWith(void Function(GetCurrentShareGroupRequest) updates) => super.copyWith((message) => updates(message as GetCurrentShareGroupRequest)) as GetCurrentShareGroupRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCurrentShareGroupRequest create() => GetCurrentShareGroupRequest._();
  GetCurrentShareGroupRequest createEmptyInstance() => create();
  static $pb.PbList<GetCurrentShareGroupRequest> createRepeated() => $pb.PbList<GetCurrentShareGroupRequest>();
  @$core.pragma('dart2js:noInline')
  static GetCurrentShareGroupRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetCurrentShareGroupRequest>(create);
  static GetCurrentShareGroupRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get groupId => $_getSZ(0);
  @$pb.TagNumber(1)
  set groupId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGroupId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroupId() => clearField(1);
}

class GetCurrentShareGroupResponse extends $pb.GeneratedMessage {
  factory GetCurrentShareGroupResponse({
    ShareGroup? shareGroup,
  }) {
    final $result = create();
    if (shareGroup != null) {
      $result.shareGroup = shareGroup;
    }
    return $result;
  }
  GetCurrentShareGroupResponse._() : super();
  factory GetCurrentShareGroupResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetCurrentShareGroupResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetCurrentShareGroupResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'Server'), createEmptyInstance: create)
    ..aOM<ShareGroup>(1, _omitFieldNames ? '' : 'shareGroup', protoName: 'shareGroup', subBuilder: ShareGroup.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetCurrentShareGroupResponse clone() => GetCurrentShareGroupResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetCurrentShareGroupResponse copyWith(void Function(GetCurrentShareGroupResponse) updates) => super.copyWith((message) => updates(message as GetCurrentShareGroupResponse)) as GetCurrentShareGroupResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCurrentShareGroupResponse create() => GetCurrentShareGroupResponse._();
  GetCurrentShareGroupResponse createEmptyInstance() => create();
  static $pb.PbList<GetCurrentShareGroupResponse> createRepeated() => $pb.PbList<GetCurrentShareGroupResponse>();
  @$core.pragma('dart2js:noInline')
  static GetCurrentShareGroupResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetCurrentShareGroupResponse>(create);
  static GetCurrentShareGroupResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ShareGroup get shareGroup => $_getN(0);
  @$pb.TagNumber(1)
  set shareGroup(ShareGroup v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasShareGroup() => $_has(0);
  @$pb.TagNumber(1)
  void clearShareGroup() => clearField(1);
  @$pb.TagNumber(1)
  ShareGroup ensureShareGroup() => $_ensure(0);
}

class UpdatePositionRequest extends $pb.GeneratedMessage {
  factory UpdatePositionRequest({
    $core.double? lat,
    $core.double? lon,
  }) {
    final $result = create();
    if (lat != null) {
      $result.lat = lat;
    }
    if (lon != null) {
      $result.lon = lon;
    }
    return $result;
  }
  UpdatePositionRequest._() : super();
  factory UpdatePositionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdatePositionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdatePositionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'Server'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'lat', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'lon', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdatePositionRequest clone() => UpdatePositionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdatePositionRequest copyWith(void Function(UpdatePositionRequest) updates) => super.copyWith((message) => updates(message as UpdatePositionRequest)) as UpdatePositionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdatePositionRequest create() => UpdatePositionRequest._();
  UpdatePositionRequest createEmptyInstance() => create();
  static $pb.PbList<UpdatePositionRequest> createRepeated() => $pb.PbList<UpdatePositionRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdatePositionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdatePositionRequest>(create);
  static UpdatePositionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get lat => $_getN(0);
  @$pb.TagNumber(1)
  set lat($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLat() => $_has(0);
  @$pb.TagNumber(1)
  void clearLat() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get lon => $_getN(1);
  @$pb.TagNumber(2)
  set lon($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLon() => $_has(1);
  @$pb.TagNumber(2)
  void clearLon() => clearField(2);
}

class UpdatePositionResponse extends $pb.GeneratedMessage {
  factory UpdatePositionResponse({
    User? user,
  }) {
    final $result = create();
    if (user != null) {
      $result.user = user;
    }
    return $result;
  }
  UpdatePositionResponse._() : super();
  factory UpdatePositionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdatePositionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdatePositionResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'Server'), createEmptyInstance: create)
    ..aOM<User>(1, _omitFieldNames ? '' : 'user', subBuilder: User.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdatePositionResponse clone() => UpdatePositionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdatePositionResponse copyWith(void Function(UpdatePositionResponse) updates) => super.copyWith((message) => updates(message as UpdatePositionResponse)) as UpdatePositionResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdatePositionResponse create() => UpdatePositionResponse._();
  UpdatePositionResponse createEmptyInstance() => create();
  static $pb.PbList<UpdatePositionResponse> createRepeated() => $pb.PbList<UpdatePositionResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdatePositionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdatePositionResponse>(create);
  static UpdatePositionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  User get user => $_getN(0);
  @$pb.TagNumber(1)
  set user(User v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => clearField(1);
  @$pb.TagNumber(1)
  User ensureUser() => $_ensure(0);
}

class GetCurrentUserRequest extends $pb.GeneratedMessage {
  factory GetCurrentUserRequest() => create();
  GetCurrentUserRequest._() : super();
  factory GetCurrentUserRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetCurrentUserRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetCurrentUserRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'Server'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetCurrentUserRequest clone() => GetCurrentUserRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetCurrentUserRequest copyWith(void Function(GetCurrentUserRequest) updates) => super.copyWith((message) => updates(message as GetCurrentUserRequest)) as GetCurrentUserRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCurrentUserRequest create() => GetCurrentUserRequest._();
  GetCurrentUserRequest createEmptyInstance() => create();
  static $pb.PbList<GetCurrentUserRequest> createRepeated() => $pb.PbList<GetCurrentUserRequest>();
  @$core.pragma('dart2js:noInline')
  static GetCurrentUserRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetCurrentUserRequest>(create);
  static GetCurrentUserRequest? _defaultInstance;
}

class GetCurrentUserResponse extends $pb.GeneratedMessage {
  factory GetCurrentUserResponse({
    User? user,
  }) {
    final $result = create();
    if (user != null) {
      $result.user = user;
    }
    return $result;
  }
  GetCurrentUserResponse._() : super();
  factory GetCurrentUserResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetCurrentUserResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetCurrentUserResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'Server'), createEmptyInstance: create)
    ..aOM<User>(1, _omitFieldNames ? '' : 'user', subBuilder: User.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetCurrentUserResponse clone() => GetCurrentUserResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetCurrentUserResponse copyWith(void Function(GetCurrentUserResponse) updates) => super.copyWith((message) => updates(message as GetCurrentUserResponse)) as GetCurrentUserResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCurrentUserResponse create() => GetCurrentUserResponse._();
  GetCurrentUserResponse createEmptyInstance() => create();
  static $pb.PbList<GetCurrentUserResponse> createRepeated() => $pb.PbList<GetCurrentUserResponse>();
  @$core.pragma('dart2js:noInline')
  static GetCurrentUserResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetCurrentUserResponse>(create);
  static GetCurrentUserResponse? _defaultInstance;

  @$pb.TagNumber(1)
  User get user => $_getN(0);
  @$pb.TagNumber(1)
  set user(User v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => clearField(1);
  @$pb.TagNumber(1)
  User ensureUser() => $_ensure(0);
}

class LeaveShareGroupRequest extends $pb.GeneratedMessage {
  factory LeaveShareGroupRequest() => create();
  LeaveShareGroupRequest._() : super();
  factory LeaveShareGroupRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LeaveShareGroupRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LeaveShareGroupRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'Server'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LeaveShareGroupRequest clone() => LeaveShareGroupRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LeaveShareGroupRequest copyWith(void Function(LeaveShareGroupRequest) updates) => super.copyWith((message) => updates(message as LeaveShareGroupRequest)) as LeaveShareGroupRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LeaveShareGroupRequest create() => LeaveShareGroupRequest._();
  LeaveShareGroupRequest createEmptyInstance() => create();
  static $pb.PbList<LeaveShareGroupRequest> createRepeated() => $pb.PbList<LeaveShareGroupRequest>();
  @$core.pragma('dart2js:noInline')
  static LeaveShareGroupRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LeaveShareGroupRequest>(create);
  static LeaveShareGroupRequest? _defaultInstance;
}

class LeaveShareGroupResponse extends $pb.GeneratedMessage {
  factory LeaveShareGroupResponse({
    User? user,
  }) {
    final $result = create();
    if (user != null) {
      $result.user = user;
    }
    return $result;
  }
  LeaveShareGroupResponse._() : super();
  factory LeaveShareGroupResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LeaveShareGroupResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LeaveShareGroupResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'Server'), createEmptyInstance: create)
    ..aOM<User>(1, _omitFieldNames ? '' : 'user', subBuilder: User.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LeaveShareGroupResponse clone() => LeaveShareGroupResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LeaveShareGroupResponse copyWith(void Function(LeaveShareGroupResponse) updates) => super.copyWith((message) => updates(message as LeaveShareGroupResponse)) as LeaveShareGroupResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LeaveShareGroupResponse create() => LeaveShareGroupResponse._();
  LeaveShareGroupResponse createEmptyInstance() => create();
  static $pb.PbList<LeaveShareGroupResponse> createRepeated() => $pb.PbList<LeaveShareGroupResponse>();
  @$core.pragma('dart2js:noInline')
  static LeaveShareGroupResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LeaveShareGroupResponse>(create);
  static LeaveShareGroupResponse? _defaultInstance;

  @$pb.TagNumber(1)
  User get user => $_getN(0);
  @$pb.TagNumber(1)
  set user(User v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => clearField(1);
  @$pb.TagNumber(1)
  User ensureUser() => $_ensure(0);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
