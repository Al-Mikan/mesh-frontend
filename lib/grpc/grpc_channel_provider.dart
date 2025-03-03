import 'package:grpc/grpc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final grpcChannelProvider = Provider.autoDispose<ClientChannel>((ref) {
  const isLocalBackend = bool.fromEnvironment("IS_LOCAL_BACKEND");
  final channel =
      isLocalBackend
          ? ClientChannel(
            'localhost',
            port: 8080,
            options: ChannelOptions(credentials: ChannelCredentials.insecure()),
          )
          : ClientChannel('egh.karintou.dev', port: 443);

  return channel;
});
