part of markhor;

class ContextMonitor {
  final List<ExecutionSpan> executionSpans = [];
  static AutonomicCell? currentCell;

  void setContext(AutonomicCell cell) => currentCell = cell;
  void endContext() => currentCell = null;
  void logSpan(ExecutionSpan span) => executionSpans.add(span);
}

class ExecutionSpan implements Storable {
  final AutonomicCell cell;
  final DateTime startTime;
  late final DateTime endTime;

  ExecutionSpan({
    required this.cell,
  }) : startTime = DateTime.now();

  Duration get duration => endTime.difference(startTime);

  @override
  Object? toStorable() => {
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'duration': duration.inMilliseconds,
      };
}
