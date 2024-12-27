part of markhor.sdk;

abstract class LCBClientInterface {
  void initClient({
    required String host,
    required int port,
    required void Function(String) onMessage,
  }) {}

  void send({
    required AutocloudArtifact destination,
    required String payload,
  });

  Future<void> closeServer();
}
