part of markhor;

class HttpRequestConfigs {
  final Duration? delay;
  final Function? failureFunction;

  const HttpRequestConfigs({
    this.delay,
    this.failureFunction,
  });
}

class Network extends Service {
  Future<T> httpRequest<T>(
    FutureOr<T> Function() fn, {
    HttpRequestConfigs? configs,
  }) async {
    if (configs != null) {
      final T result = await fn();
      return await Future.delayed(
        configs.delay ?? Duration.zero,
        () {
          if (configs.failureFunction != null) {
            return configs.failureFunction!();
          } else {
            return result;
          }
        },
      );
    } else {
      return fn();
    }
  }
}
