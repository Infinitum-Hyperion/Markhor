part of markhor;

abstract class Report extends StorableJson {
  final DateTimeStorable timestamp = DateTimeStorable(DateTime.now());
  Report();

  @override
  Map<String, Object?> toJson() {
    return {
      'timestamp': timestamp.toStorable(),
    };
  }
}

mixin Publishing<R extends Report> {
  final StreamController<R> _streamController = StreamController.broadcast();
  late final Stream<R> stream = _streamController.stream;
  void publishReport(R report) => _streamController.add(report);
}
