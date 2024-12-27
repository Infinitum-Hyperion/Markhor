import 'package:markhor_sdk/markhor_sdk.dart';
import 'package:autocloud_sdk/autocloud_sdk.dart';

import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/status.dart' as WSStatus;

class LCBClient extends LCBClientInterface {
  HtmlWebSocketChannel? socket;

  @override
  void initClient({
    required String host,
    required int port,
    required void Function(String) onMessage,
  }) async {
    socket = HtmlWebSocketChannel.connect("ws://$host:$port");
    socket!.stream.listen((message) => onMessage(message));
  }

  @override
  void send({
    required AutocloudArtifact destination,
    required String payload,
  }) {
    socket!.sink.add("preflight:${destination.id}");
    socket!.sink.add(payload);
  }

  @override
  Future<void> closeServer() async {
    await socket?.sink.close(WSStatus.goingAway);
  }
}
