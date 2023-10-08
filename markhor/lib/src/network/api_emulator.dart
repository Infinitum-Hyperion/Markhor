part of markhor;

abstract class APIEmulator extends AutonomicElement {
  final Observatory? observatory;
  final TelemetryChannel? channel;
  late final HttpServer _httpServer;

  APIEmulator({
    this.observatory,
    this.channel,
    required super.elementId,
    required super.systemId,
  });

  String get urlAddress => _httpServer.address.toString();

  Future<void> initServer([int port = 42001]) async {
    _httpServer = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
    _httpServer.listen((HttpRequest request) async {
      final HttpResponse response = handleRequest(request);
      if (observatory != null && channel != null) {
        observatory!.datahouse.publishTo(
          channel: channel!,
          item: TelemetryItem(
            systemId: systemId,
            payload: APIEmulatorReport(request: request, response: response),
          ),
        );
      }
      (APIEmulatorReport(request: request, response: response));
      await response.close();
    });
  }

  HttpResponse handleRequest(HttpRequest request);
}

class APIEmulatorReport extends StorableJson {
  final HttpRequest request;
  final HttpResponse response;

  APIEmulatorReport({
    required this.request,
    required this.response,
  });

  @override
  Map<String, Object?> toJson() => {
        'request': request.uri.toString(),
        'response': response.statusCode,
      };
}
