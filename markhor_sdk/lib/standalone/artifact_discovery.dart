library markhor.sdk.communication.artifact_discovery;

import 'dart:convert';
import 'dart:io';

import 'package:autocloud_sdk/autocloud_sdk.dart';

class ArtifactDiscoveryService {
  final AutocloudProject project;
  final Map<String, WebSocket> sockets = {};
  final Map<String, String> preflightInfo = {};

  ArtifactDiscoveryService({
    required this.project,
  });

  /// Creates a server corresponding to each [ArtifactSocket]. Forwards data received
  /// on each socket to the specified destination.
  void init() async {
    for (final entity in project.entities) {
      if (entity is AutocloudArtifact) {
        if (entity.socket != null) {
          (await HttpServer.bind(entity.socket!.host, entity.socket!.port))
              .listen((request) async {
            if (WebSocketTransformer.isUpgradeRequest(request)) {
              final websocket = await WebSocketTransformer.upgrade(request);
              sockets.addAll({entity.id: websocket});
              websocket.listen(
                (data) {
                  standardForwarder(data, entity.id);
                },
                onError: socketErrorHandler,
                onDone: () => socketDisconnectHandler(entity.id),
              );
            }
          });
        }
      }
    }
  }

  /// Handles forwarding of data to different sockets based on the protocol:
  /// 1. Every incoming payload to the Websocket must be preceded by a pre-flight [String] object
  /// 2. The pre-flight object specifies the destination ID (as given by `AutocloudEntity.id`) of the actual payload
  void standardForwarder(String data, String socketId) {
    if (data.startsWith('preflight:')) {
      final String dest = data.replaceAll('preflight:', '');
      if (sockets.keys.contains(dest)) {
        preflightInfo[socketId] = dest;
      } else {
        sendMessage(
          jsonEncode({
            "source": "artifact-discovery",
            "code": "failed",
            "msg":
                "destination '$dest' not found in artifact discovery registry",
            "registry_state": sockets.keys.toList(),
          }),
          socketId,
        );
      }
    } else {
      if (preflightInfo.keys.contains(socketId)) {
        final String dest = preflightInfo[socketId]!;
        sendMessage(data, dest);
        preflightInfo.remove(socketId);
      } else {
        sendMessage(
          jsonEncode({
            "source": "artifact-discovery",
            "code": "failed",
            "msg": "Need to specify destination in a preflight message",
          }),
          socketId,
        );
      }
    }
  }

  void socketErrorHandler(e, st) {
    print("artifact discovery: ERROR: $e");
    print(st);
  }

  void sendMessage(String data, String socketId) {
    sockets[socketId]!.add(data);
  }

  void socketDisconnectHandler(String socketId) {
    preflightInfo.remove(socketId);

    sockets.remove(socketId);
  }

  Future<void> closeServers() async {
    for (final String socketId in sockets.keys) {
      await sockets[socketId]!.close();
    }
  }
}
