import 'package:grpc/grpc.dart';
import 'package:mesh_frontend/grpc/gen/server.pbgrpc.dart';

class GrpcService {
  static Future<GetCurrentUserResponse> getCurrentUser(
    ClientChannel channel,
    String accessToken,
  ) async {
    final client = ServiceClient(channel);
    final res = await client.getCurrentUser(
      GetCurrentUserRequest(),
      options: CallOptions(metadata: {'token': accessToken}),
    );
    return res;
  }

  static Future<AnonymousSignUpResponse> anonymousSignUp(
    ClientChannel channel,
    String name,
    String iconID,
  ) async {
    final client = ServiceClient(channel);
    final res = await client.anonymousSignUp(
      AnonymousSignUpRequest(name: name, iconID: iconID),
    );
    return res;
  }

  static Future<CreateShareGroupResponse> createShareGroup(
    ClientChannel channel,
    double destLat,
    double destLon,
    String sharingLocationStartTime,
    String meetingTime,
    String address,
    String accessToken,
  ) async {
    final client = ServiceClient(channel);
    final res = await client.createShareGroup(
      CreateShareGroupRequest(
        destLat: destLat,
        destLon: destLon,
        sharingLocationStartTime:sharingLocationStartTime,
        meetingTime: meetingTime,
        address: address,
      ),
      options: CallOptions(metadata: {'token': accessToken}),
    );
    return res;
  }

  static Future<GetShareGroupByLinkKeyResponse> getShareGroupByLinkKey(
    ClientChannel channel,
    String groupId, // TODO: 名前を統一
  ) async {
    final client = ServiceClient(channel);
    final res = await client.getShareGroupByLinkKey(
      GetShareGroupByLinkKeyRequest(linkKey: groupId),
    );
    return res;
  }

  static Future<JoinShareGroupResponse> joinShareGroupRequest(
    ClientChannel channel,
    String groupId, // TODO: 名前を統一
    String accessToken,
  ) async {
    final client = ServiceClient(channel);
    final res = await client.joinShareGroup(
      JoinShareGroupRequest(linkKey: groupId),
      options: CallOptions(metadata: {'token': accessToken}),
    );
    return res;
  }

  static Future<UpdatePositionResponse> updatePosition(
    ClientChannel channel,
    double lat,
    double lon,
    String accessToken,
  ) async {
    final client = ServiceClient(channel);
    final res = await client.updatePosition(
      UpdatePositionRequest(lat: lat, lon: lon),
      options: CallOptions(metadata: {'token': accessToken}),
    );
    return res;
  }

  static Future<ArriveDestResponse> arriveDest(
    ClientChannel channel,
    String accessToken,
  ) async {
    final client = ServiceClient(channel);
    final res = await client.arriveDest(
      ArriveDestRequest(),
      options: CallOptions(metadata: {'token': accessToken}),
    );
    return res;
  }

  static Future<LeaveShareGroupResponse> leaveShareGroup(
    ClientChannel channel,
    String accessToken,
  ) async {
    final client = ServiceClient(channel);
    final res = await client.leaveShareGroup(
      LeaveShareGroupRequest(),
      options: CallOptions(metadata: {'token': accessToken}),
    );
    return res;
  }

  // Streamで位置情報を取得
  static Stream<GetCurrentShareGroupResponse> getCurrentShareGroupStream(
    ClientChannel channel,
    String accessToken,
  ) async* {
    final client = ServiceClient(channel);
    final stream = client.getCurrentShareGroupServerStream(
      GetCurrentShareGroupRequest(),
      options: CallOptions(metadata: {'token': accessToken}),
    );
    await for (final response in stream) {
      yield response;
    }
  }

  static Future<UpdateShortMessageResponse> updateShortMessage(
    ClientChannel channel,
    String? message,
    String accessToken,
  ) async {
    final client = ServiceClient(channel);
    final res = await client.updateShortMessage(
      UpdateShortMessageRequest(shortMessage: message),
      options: CallOptions(metadata: {'token': accessToken}),
    );
    return res;
  }
}
