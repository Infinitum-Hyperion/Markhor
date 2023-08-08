part of markhor;

class MethodInvocationObserver<T> extends WorkstationNode
    with Publishing<MethodInvocationReport> {
  final Stopwatch stopwatch = Stopwatch();

  T call(T Function() subject) {
    // Start tracking
    stopwatch.start();
    final T returnValue = subject();
    stopwatch.stop();

    // Log, and take measurements
    publishReport(
      MethodInvocationReport(
        executionDuration: Duration(
          milliseconds: stopwatch.elapsedMilliseconds,
        ),
      ),
    );

    // Reset variables
    stopwatch.reset();
    return returnValue;
  }

  @override
  String toString() => 'MethodInvocationObserver';
}

class MethodInvocationReport extends Report {
  final Duration executionDuration;

  MethodInvocationReport({
    required this.executionDuration,
  });

  @override
  String toString() => "${executionDuration.inMilliseconds}ms";
}
