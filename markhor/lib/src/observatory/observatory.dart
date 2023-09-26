part of markhor;

/// The Markhor [Observatory] provides telemetry tracking services
class Observatory {
  final Datahouse datahouse;
  final ContextMonitor contextMonitor;
  final LogMonitor logMonitor;

  Observatory({
    required this.datahouse,
    required this.contextMonitor,
    required this.logMonitor,
  });
}

/// A [SystemParameter] is a paramter that is tracked by the system to ensure
/// compliance.
class SystemParameter {}
