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
    String accessToken,
  ) async {
    final client = ServiceClient(channel);
    final res = await client.createShareGroup(
      CreateShareGroupRequest(
        destLat: destLat,
        destLon: destLon,
        meetingTime: meetingTime,
      ),
      options: CallOptions(metadata: {'token': accessToken}),
    );
    return res;
  }
}
