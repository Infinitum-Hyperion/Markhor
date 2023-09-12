part of markhor;

/// The Markhor [Observatory] provides telemetry tracking services
class Observatory {
  final AutocloudWorkstation workstation;
  final Map<WorkstationComponent, List<Report>> repository = {};

  Observatory({
    required this.workstation,
  });

  void attachPublisherFor<R extends Report>(WorkstationComponent component) {
    repository.addAll({component: []});
    // can call updateConsole in the future when there IS a console
    // component.stream.listen((R report) => repository[publisher]!.add(report));
  }

  void dump() {
    for (WorkstationComponent component in repository.keys) {
      print('\n\nPUB: $component');
      print(
        repository[component]!
            .map((Report r) => "  ${r.timestamp.toIso8601String()} | $r")
            .toList()
            .join('\n'),
      );
    }
  }
}

abstract class Report {
  final DateTime timestamp = DateTime.now();
  Report();
}

mixin Publishing<R extends Report> on WorkstationComponent {
  final StreamController<R> _streamController = StreamController.broadcast();
  late final Stream<R> stream = _streamController.stream;
  void publishReport(R report) => _streamController.add(report);
}

/// A [SystemParameter] is a paramter that is tracked by the system to ensure
/// compliance.
class SystemParameter {}
