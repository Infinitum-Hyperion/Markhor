part of markhor.sdk;

/// Borrowing from reinforcement learning lingo, a [ReplayBuffer] is a wrapper over
/// variables which are used to store live data. Instead of having to run a simulation
/// over and over again to test changes to other part of the system, the buffer stores
/// the value from one execution and reuses the same value. Do not instantiate [ReplayBuffer]
/// instances directly. Instead, use the [AutocloudProject.createReplayBuffer] method.
class ReplayBuffer<T> {
  final String id;
  final KeyValueDBProvider dbProvider;
  final T Function() actualFunction;

  ReplayBuffer(
    this.id, {
    required this.dbProvider,
    required this.actualFunction,
  });

  /// This method is to store values as-is in the Firestore database. Use this method
  /// for primitive types and basic data structures such as Maps and Lists of primitive objects.
  /// For user-defined classes, use the [getAndConvertFrom] method. A small caveat is that
  /// any function call that utilises the [ReplayBuffer] methods must be `async` to allow
  /// for DB operations to be performed.
  Future<T> get() async {
    if (AutocloudProject.executionMode == ExecutionMode.debug) {
      final KVDBObjectIdentityProvider bufferId =
          KeyValueDBProvider.markhorReplayBuffersStore.appendField(id);
      T? bufferedValue = await dbProvider.getById(bufferId);
      if (bufferedValue == null) {
        bufferedValue = actualFunction();
        print('updating value');
        await dbProvider.updateById(bufferId, bufferedValue);
      } else {
        print('fetching buffered value');
      }
      return bufferedValue!;
    } else {
      return actualFunction();
    }
  }

  Future<T> getAndConvertFrom<S>({
    required T Function(S) convertToNative,
    required S Function(T) convertToStorable,
  }) async {
    if (AutocloudProject.executionMode == ExecutionMode.debug) {
      final KVDBObjectIdentityProvider bufferId =
          KeyValueDBProvider.markhorReplayBuffersStore.appendField(id);
      S? bufferedValue = await dbProvider.getById(bufferId);
      T finalValue;
      if (bufferedValue == null) {
        finalValue = actualFunction();
        bufferedValue = convertToStorable(finalValue);
        await dbProvider.updateById(bufferId, bufferedValue);
      } else {
        finalValue = convertToNative(bufferedValue);
      }
      return finalValue;
    } else {
      return actualFunction();
    }
  }
}
