part of markhor;

/// The Markhor [Observatory] provides telemetry tracking services
class Observatory {
  final Datahouse datahouse;
  final ContextMonitor contextMonitor;
  final LogMonitor logMonitor;

  const Observatory({
    required this.datahouse,
    required this.contextMonitor,
    required this.logMonitor,
  });
}
