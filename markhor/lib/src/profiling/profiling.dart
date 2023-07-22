part of markhor;

class MethodInvocationObserver<R> {
  final Map<DateTime, MethodInvocationReport> report = {};
  final Stopwatch stopwatch = Stopwatch();

  MethodInvocationObserver();

  R call(R Function() subject) {
    stopwatch.start();
    final R returnValue = subject();
    stopwatch.stop();
    report.addAll({
      DateTime.now(): MethodInvocationReport(
        executionDuration: Duration(
          milliseconds: stopwatch.elapsedMilliseconds,
        ),
      )
    });
    stopwatch.reset();
    return returnValue;
  }
}

class MethodInvocationReport {
  final Duration executionDuration;

  const MethodInvocationReport({
    required this.executionDuration,
  });
}
