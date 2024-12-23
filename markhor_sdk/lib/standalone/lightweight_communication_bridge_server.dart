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
    print('initialising');
    (await HttpServer.bind('0.0.0.0', receptionPort)).listen((request) async {
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        print('received upgrade request');
        receptionSocket = await WebSocketTransformer.upgrade(request);
        print('listening');
        receptionSocket!.listen(
          forwardingSocket?.add,
          onError: (e, st) {
            print(e);
            print(st);
          },
          onDone: () => print('client disconnected'),
        );
      } else {
        print('bad request');
        request.response.statusCode = HttpStatus.badRequest;
        await request.response.close();
      }
    });
    (await HttpServer.bind('0.0.0.0', forwardingPort)).listen((request) async {
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        forwardingSocket = await WebSocketTransformer.upgrade(request);
        forwardingSocket!.listen(
          receptionSocket?.add,
          onError: (e, st) {
            print(e);
            print(st);
          },
          onDone: () => print('client disconnected'),
        );
      } else {
        print('bad request');
        request.response.statusCode = HttpStatus.badRequest;
        await request.response.close();
      }
    });
  }

  Future<void> closeServers() async {
    await forwardingSocket?.close();
    await receptionSocket?.close();
  }
}
