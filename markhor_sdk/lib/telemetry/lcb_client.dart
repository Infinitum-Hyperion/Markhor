part of markhor.sdk;

class LCBClient {
  HtmlWebSocketChannel? socket;
  void initClient({
    int port = 8081,
    required void Function(String) onMessage,
  }) async {
    socket = HtmlWebSocketChannel.connect("ws://0.0.0.0:$port");
    socket!.stream.listen((message) => onMessage(message));
  }

  void send(String msg) => socket!.sink.add(msg);

  Future<void> closeServer() async {
    await socket?.sink.close(WSStatus.goingAway);
  }
}
