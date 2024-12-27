import 'package:autocloud_sdk/autocloud_sdk.dart';
import 'package:markhor_sdk/markhor_sdk.dart';

class LCBClient extends LCBClientInterface {
  @override
  void initClient({
    required String host,
    required int port,
    required void Function(String) onMessage,
  }) {}

  @override
  void send({required AutocloudArtifact destination, required String payload}) {
    // TODO: implement send
    throw UnimplementedError();
  }

  @override
  Future<void> closeServer() {
    // TODO: implement closeServer
    throw UnimplementedError();
  }
}
