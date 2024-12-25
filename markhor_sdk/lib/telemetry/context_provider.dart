part of markhor.sdk;

abstract class Logger {
  void info(String msg);
  void warn(String msg);
  void error(String msg);
}

abstract class ContextProvider {
  final Logger logger;

  const ContextProvider({
    required this.logger,
  });

  void startExec(String name);
  void endExec(String name);
}

class OTelLogger extends Logger {
  @override
  void info(String msg) {
    // TODO: implement info
  }
  @override
  void warn(String msg) {
    // TODO: implement warn
  }
  @override
  void error(String msg) {
    // TODO: implement error
  }
}

class DartContextProvider extends ContextProvider {
  const DartContextProvider({
    required super.logger,
  });

  @override
  void startExec(String name) {
    // TODO: implement startExec
  }
  @override
  void endExec(String name) {
    // TODO: implement endExec
  }
}
