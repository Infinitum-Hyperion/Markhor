part of markhor.sdk;

class LCBClient {
  HtmlWebSocketChannel? socket;
  void initClient({
    int port = 8081,
    required void Function(String) onMessage,
  }) async {
    socket = HtmlWebSocketChannel.connect("ws://localhost:$port");
    socket!.stream.listen((message) => onMessage(message));
  }

  Future<void> closeServer() async {
    await socket?.sink.close(WSStatus.goingAway);
  }
}
