part of markhor;

class Observatory {
  final Map<Publisher, List<Report>> repository = {};

  void attachPublisherFor<R extends Report>(Publisher<R> publisher) {
    repository.addAll({publisher: <R>[]});
    // can call updateConsole in the future when there IS a console
    publisher.stream.listen((R report) => repository[publisher]!.add(report));
  }

  void dump() {
    for (Publisher publisher in repository.keys) {
      print('\n\nPUB: $publisher');
      print(
        repository[publisher]!
            .map((Report r) => "  ${r.timestamp.toIso8601String()} | $r")
            .toList()
            .join('\n'),
      );
    }
  }
}

abstract class Publisher<R extends Report> {
  final StreamController<R> _streamController = StreamController.broadcast();
  late final Stream<R> stream = _streamController.stream;

  void publishReport(R report) => _streamController.add(report);
}

abstract class Report {
  final DateTime timestamp = DateTime.now();
  Report();
}
