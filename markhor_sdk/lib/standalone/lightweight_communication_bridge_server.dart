library markhor.sdk.communication.lcb;

import 'dart:io';

class LightweightCommunicationBridgeForwarder {
  WebSocket? receptionSocket;
  WebSocket? forwardingSocket;

  /// Creates a server on ports 8080 (for communicating with the target system)
  /// and 8081 (for communicating with the autonomic system).
  void initServers({
    int receptionPort = 8080,
    int forwardingPort = 8081,
  }) async {
    (await HttpServer.bind('localhost', receptionPort)).listen((request) async {
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        receptionSocket = await WebSocketTransformer.upgrade(request);
        receptionSocket!.listen(forwardingSocket?.add);
      }
    });
    (await HttpServer.bind('localhost', forwardingPort))
        .listen((request) async {
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        forwardingSocket = await WebSocketTransformer.upgrade(request);
        forwardingSocket!.listen(receptionSocket?.add);
      }
    });
  }

  Future<void> closeServers() async {
    await forwardingSocket?.close();
    await receptionSocket?.close();
  }
}
