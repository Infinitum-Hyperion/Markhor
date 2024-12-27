import 'dart:async';

import 'package:markhor_sdk/markhor_sdk.dart';

class ContextProvider extends ContextProviderInterface {
  ContextProvider({
    required super.artifact,
  });

  @override
  FutureOr<T> executeSpan<T>(
    String label,
    FutureOr<T> Function(Logger) method,
  ) {
    throw UnimplementedError();
  }
}
