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
    print('Initialising target->system forwarder');
    (await HttpServer.bind('0.0.0.0', receptionPort)).listen((request) async {
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        receptionSocket = await WebSocketTransformer.upgrade(request);
        print('TSF Listening');
        receptionSocket!.listen(
          (data) {
            print('Forwarding from target to system');
            forwardingSocket?.add(data);
          },
          onError: (e, st) {
            print(e);
            print(st);
          },
          onDone: () => print('Target disconnected'),
        );
      } else {
        print('bad request');
        request.response.statusCode = HttpStatus.badRequest;
        await request.response.close();
      }
    });
    print('Initialising system->target forwarder');
    (await HttpServer.bind('0.0.0.0', forwardingPort)).listen((request) async {
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        forwardingSocket = await WebSocketTransformer.upgrade(request);
        print('STF Listening');
        forwardingSocket!.listen(
          (data) {
            print('Forwarding from system to target');
            receptionSocket?.add(data);
          },
          onError: (e, st) {
            print(e);
            print(st);
          },
          onDone: () => print('System disconnected'),
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
