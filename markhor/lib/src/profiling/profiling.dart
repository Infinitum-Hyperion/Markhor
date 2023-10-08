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
      item: TelemetryItem(
        systemId: systemId,
        payload: MethodInvocationReport(
          executionDuration: DurationStorable(Duration(
            milliseconds: stopwatch.elapsedMilliseconds,
          )),
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

class MethodInvocationReport extends StorableJson {
  final DurationStorable executionDuration;

  MethodInvocationReport({
    required this.executionDuration,
  });

  @override
  String toString() => "${executionDuration.toStorable()}ms";

  @override
  Map<String, Object?> toJson() => {
        'executionDuration': executionDuration.toStorable(),
      };
}
