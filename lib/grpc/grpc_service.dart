import 'package:grpc/grpc.dart';
import 'package:mesh_frontend/grpc_gen/server.pbgrpc.dart';

class GrpcService {
  static Future<GetCurrentUserResponse> getCurrentUser(
    ClientChannel channel,
  ) async {
    final client = ServiceClient(channel);
    final res = await client.getCurrentUser(GetCurrentUserRequest());
    return res;
  }
}
