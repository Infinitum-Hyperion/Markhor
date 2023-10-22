part of markhor;

class Datahouse {
  final Map<TelemetryChannel, List<ChannelListener>> registry = {};

  void addChannel<S extends Storable<JSON>>({
    required TelemetryChannel<S> channel,
  }) =>
      registry[channel] = [];

  void addListener<S extends Storable<JSON>>({
    required TelemetryChannel<S> channel,
    required ChannelListener<S> listener,
  }) {
    if (registry.containsKey(channel)) {
      registry[channel]!.add(listener);
    } else {
      registry[channel] = [listener];
    }
  }

  void publishTo<S extends Storable<JSON>>({
    required TelemetryChannel<S> channel,
    required TelemetryItem<S> item,
  }) {
    if (registry.containsKey(channel)) {
      channel.items.add(item);
      for (ChannelListener cl in registry[channel]!) {
        cl.notifier.call(item);
      }
    } else {
      throw "Channel not exist";
    }
  }
}

class ChannelListener<S extends Storable<JSON>> {
  final void Function(TelemetryItem<S>) notifier;

  const ChannelListener({
    required this.notifier,
  });
}
