part of markhor;

abstract class APIEmulator extends WorkstationAgent
    with Publishing<APIEmulatorReport> {
  late final HttpServer _httpServer;
  APIEmulator({
    int port = 42069,
  }) {
    workstation?._asyncInitialisations.add(initServer(port));
  }

  String get urlAddress => _httpServer.address.toString();

  Future<void> initServer([int port = 42069]) async {
    _httpServer = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
    _httpServer.listen((HttpRequest request) async {
      final HttpResponse response = handleRequest(request);
      publishReport(APIEmulatorReport(request: request, response: response));
      await response.close();
    });
  }

  HttpResponse handleRequest(HttpRequest request);
}

class APIEmulatorReport extends Report {
  final HttpRequest request;
  final HttpResponse response;

  APIEmulatorReport({
    required this.request,
    required this.response,
  });
}
