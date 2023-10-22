part of markhor;

class MethodInvocationObserver<T> extends AutonomicElement {
  final Observatory observatory;
  final TelemetryChannel channel;
  final Stopwatch stopwatch = Stopwatch();

  MethodInvocationObserver({
    required this.observatory,
    required this.channel,
    required super.elementId,
    required super.systemId,
  });

  T call(T Function() subject) {
    // Start tracking
    stopwatch.start();
    final T returnValue = subject();
    stopwatch.stop();

    // Log, and take measurements
    observatory.datahouse.publishTo(
      channel: channel,
      item: TelemetryItem<MethodInvocationReport>(
        systemId: systemId,
        payload: MethodInvocationReport(
          executionDuration: Duration(
            milliseconds: stopwatch.elapsedMilliseconds,
          ),
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

class MethodInvocationReport with Storable<JSON> {
  final Duration executionDuration;

  MethodInvocationReport({
    required this.executionDuration,
  });

  @override
  String toString() => "${executionDuration.serialize()}ms";

  @override
  JSON serialize() => {
        'executionDuration': executionDuration.serialize(),
      };
}
