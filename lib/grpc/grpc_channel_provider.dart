import 'package:grpc/grpc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final grpcChannelProvider = Provider.autoDispose<ClientChannel>((ref) {
  final channel = ClientChannel(
    'localhost',
    port: 8080,
    options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
  );

  return channel;
});
