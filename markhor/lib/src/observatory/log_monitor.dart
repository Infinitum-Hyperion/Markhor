part of markhor;

class LogMonitor {
  final List<Log> logs = [];

  void log(Log log) => logs.add(log);
}

enum LogType {
  info('INFO'),
  warn('WARN'),
  error(' ERR');

  final String abbr;
  const LogType(this.abbr);
}

class Log {
  final AutonomicElement source;
  final LogType logType;
  final String message;
  final dynamic payload;

  const Log({
    required this.logType,
    required this.source,
    required this.message,
    required this.payload,
  });
}

mixin Logging on AutonomicCell {
  void logInfo(String message, [dynamic payload]) => observatory.logMonitor.log(
        Log(
            logType: LogType.info,
            source: this,
            message: message,
            payload: payload),
      );
  void logWarn(String message, [dynamic payload]) => observatory.logMonitor.log(
        Log(
            logType: LogType.warn,
            source: this,
            message: message,
            payload: payload),
      );
  void logError(String message, [dynamic payload]) =>
      observatory.logMonitor.log(
        Log(
            logType: LogType.error,
            source: this,
            message: message,
            payload: payload),
      );
}
