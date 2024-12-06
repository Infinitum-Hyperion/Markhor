part of markhor.sdk;

class LightweightCommunicationBridge {
  late final WebSocket socket;
  void initServer([int port = 8080]) async {
    (await HttpServer.bind('localhost', port)).listen((request) async {
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        socket = await WebSocketTransformer.upgrade(request);
        socket
          ..add(jsonEncode({'tag': 'hello'}))
          ..listen((message) async {
            if (jsonDecode(message)['tag'] == 'close') {
              await closeServer();
              exit(0);
            }
          });
      }
    });
  }

  Future<void> closeServer() async {
    await socket.close();
  }
}
