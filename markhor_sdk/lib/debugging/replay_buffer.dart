part of markhor.sdk;

/// Borrowing from reinforcement learning lingo, a [ReplayBuffer] is a wrapper over
/// variables which are used to store live data. Instead of having to run a simulation
/// over and over again to test changes to other part of the system, the buffer stores
/// the value from one execution and reuses the same value. Do not instantiate [ReplayBuffer]
/// instances directly. Instead, use the [AutocloudProject.createReplayBuffer] method.
class ReplayBuffer<T> {
  final String id;
  final KeyValueDBProvider kvDBProvider;
  final BlobDBProvider blobDBProvider;
  final T Function() actualFunction;
  final bool enabled;

  ReplayBuffer(
    this.id, {
    required this.kvDBProvider,
    required this.blobDBProvider,
    required this.actualFunction,
    required this.enabled,
  });

  Future<T?> getKVDBBuffer(String bufferId) async {
    return await kvDBProvider.getById(bufferId, id);
  }

  Future<T?> getBlobBuffer(String bufferId) async {
    final result = await blobDBProvider.get(bufferId);
    if (result == null) return null;
    return jsonDecode(utf8.decode(result));
  }

  /// This method is to store values in the Replay Buffer. Since the values themselves may be
  /// too large for a key-value database, a [BlobDBProvider] is relied upon to store the data.
  /// The path/reference/link to the blob is then stored by the [KeyValueDBProvider] for the
  /// corresponding variable. Use this method for primitive types and basic data structures
  /// such as Maps and Lists of primitive objects. For user-defined classes, use the [getAndConvertFrom]
  /// method. A small caveat is that any function call that utilises the [ReplayBuffer] methods must be
  /// `async` to allow for DB operations to be performed.
  Future<T> get() async {
    if (AutocloudProject.executionMode == ExecutionMode.debug && enabled) {
      final String bufferLoc = KeyValueDBProvider.markhorReplayBuffersStore;
      // This might contain either the buffer value itself, or a blob reference, or nothing at all
      final dynamic bufferRetrievalAttempt =
          await kvDBProvider.getById(bufferLoc, id);
      T? bufferedValue;
      if (bufferRetrievalAttempt is String) {
        if (T == String) {
          bufferedValue = bufferRetrievalAttempt as T;
        } else {
          // Stored as a blob, whose path is stored by `bufferRetrievalAttempt`
          bufferedValue = await getBlobBuffer(bufferRetrievalAttempt);
        }
      } else if (bufferRetrievalAttempt != null) {
        // The buffer retrieval attempt was successful
        bufferedValue = bufferRetrievalAttempt;
      } else {
        bool isTypeLargeObjType;
        // Detect the type of the variable
        if (T == String) {
          isTypeLargeObjType = false;
        } else if (T.toString().contains('Map') ||
            T.toString().contains('List')) {
          // This is pathetic comparison logic but we really need to move on from this issue
          isTypeLargeObjType = true;
        } else {
          throw UnimplementedError();
        }
        // Update the appropriate type of DB with the new buffer value
        bufferedValue = actualFunction();
        if (isTypeLargeObjType) {
          final String blobId = "$bufferLoc/$id";
          await blobDBProvider.put(
              blobId, utf8.encode(jsonEncode(bufferedValue)));
          await kvDBProvider.updateById(bufferLoc, id, blobId);
        } else {
          await kvDBProvider.updateById(bufferLoc, id, bufferedValue);
        }
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
      final String bufferLoc = KeyValueDBProvider.markhorReplayBuffersStore;

      S? bufferedValue = await kvDBProvider.getById(bufferLoc, id);
      T finalValue;
      if (bufferedValue == null) {
        finalValue = actualFunction();
        bufferedValue = convertToStorable(finalValue);
        await kvDBProvider.updateById(bufferLoc, id, bufferedValue);
      } else {
        finalValue = convertToNative(bufferedValue);
      }
      return finalValue;
    } else {
      return actualFunction();
    }
  }
}
