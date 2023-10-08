part of markhor;

class TelemetryChannel<S extends StorableJson> {
  final String systemId;
  final List<TelemetryItem<S>> items = [];

  TelemetryChannel({
    required this.systemId,
  });
}

class TelemetryItem<S extends Storable> implements Storable {
  final String systemId;
  final S payload;
  final DateTimeStorable dateTime;

  TelemetryItem({
    required this.systemId,
    required this.payload,
  }) : dateTime = DateTimeStorable(DateTime.now());

  @override
  Object? toStorable() => {
        'systemId': systemId,
        'timestamp': dateTime.toStorable(),
        'payload': payload.toStorable(),
      };
}
