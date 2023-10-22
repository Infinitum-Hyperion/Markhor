part of markhor;

class TelemetryChannel<S extends Storable<JSON>> {
  final String systemId;
  final List<TelemetryItem> items = [];

  TelemetryChannel({
    required this.systemId,
  });
}

class TelemetryItem with Storable<JSON> {
  final String systemId;
  final JSON payload;
  final DateTime dateTime;

  TelemetryItem({
    required this.systemId,
    required this.payload,
  }) : dateTime = DateTime.now();

  factory TelemetryItem.fromStorable(Object? storable) {
    final JSON json = storable as JSON;
    return TelemetryItem(
      systemId: json.get<String>('systemId'),
      payload: json.get<JSON>('payload'),
    );
  }

  @override
  JSON serialize() => {
        'systemId': systemId,
        'timestamp': dateTime.serialize(),
        'payload': payload,
      };
}
