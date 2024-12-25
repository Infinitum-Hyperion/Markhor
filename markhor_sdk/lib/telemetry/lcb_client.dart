import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/status.dart' as WSStatus;
import 'package:autocloud_sdk/autocloud_sdk.dart';

class LCBClient {
  HtmlWebSocketChannel? socket;
  void initClient({
    required String host,
    required int port,
    required void Function(String) onMessage,
  }) async {
    socket = HtmlWebSocketChannel.connect("ws://$host:$port");
    socket!.stream.listen((message) => onMessage(message));
  }

  void send({
    required AutocloudArtifact destination,
    required String payload,
  }) {
    socket!.sink.add("preflight:${destination.id}");
    socket!.sink.add(payload);
  }

  Future<void> closeServer() async {
    await socket?.sink.close(WSStatus.goingAway);
  }
}
