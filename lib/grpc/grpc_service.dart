import 'package:grpc/grpc.dart';
import 'package:mesh_frontend/grpc/gen/server.pbgrpc.dart';

class GrpcService {
  static Future<GetCurrentUserResponse> getCurrentUser(
    ClientChannel channel,
  ) async {
    final client = ServiceClient(channel);
    final res = await client.getCurrentUser(GetCurrentUserRequest());
    return res;
  }

  static Future<AnonymousSignUpResponse> anonymousSignUp(
    ClientChannel channel,
    String name,
  ) async {
    final client = ServiceClient(channel);
    final res = await client.anonymousSignUp(
      AnonymousSignUpRequest(name: name),
    );
    return res;
  }

  static Future<CreateShareGroupResponse> createShareGroup(
    ClientChannel channel,
    double destLat,
    double destLon,
    String meetingTime,
    String address,
    String accessToken,
  ) async {
    final client = ServiceClient(channel);
    final res = await client.createShareGroup(
      CreateShareGroupRequest(
        destLat: destLat,
        destLon: destLon,
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
}
