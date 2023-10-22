part of markhor;

class TelemetryChannel<S extends Storable<JSON>> {
  final String systemId;
  final List<TelemetryItem<S>> items = [];

  TelemetryChannel({
    required this.systemId,
  });
}

class TelemetryItem<S extends Storable<JSON>> with Storable<JSON> {
  final String systemId;
  final S payload;
  final DateTime dateTime;

  TelemetryItem({
    required this.systemId,
    required this.payload,
  }) : dateTime = DateTime.now();

  @override
  JSON serialize() => {
        'systemId': systemId,
        'timestamp': dateTime.serialize(),
        'payload': payload.serialize(),
      };
}
