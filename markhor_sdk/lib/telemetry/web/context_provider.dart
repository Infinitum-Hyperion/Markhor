import 'dart:async';
import 'package:markhor_sdk/markhor_sdk.dart';
import 'package:opentelemetry/sdk.dart';
import 'package:opentelemetry/api.dart';

class ContextProvider extends ContextProviderInterface {
  final _tracerProvider = TracerProviderBase(
    processors: [
      BatchSpanProcessor(
        CollectorExporter(
          Uri.parse('my'),
        ),
      ),
    ],
  );
  late final Tracer tracer;
  Span? currentSpan;

  ContextProvider({
    required super.artifact,
  }) {
    registerGlobalTracerProvider(_tracerProvider);
    tracer = globalTracerProvider.getTracer(artifact.id);
  }

  @override
  FutureOr<T> executeSpan<T>(
    String label,
    FutureOr<T> Function(Logger) method,
  ) async {
    final span = tracer.startSpan(label);
    final Logger logger = Logger(
      info: span.addEvent,
      warn: span.addEvent,
      error: span.addEvent,
    );
    try {
      return await method(logger);
    } catch (e, st) {
      span
        ..setStatus(StatusCode.error, e.toString())
        ..recordException(e, stackTrace: st);
      rethrow;
    } finally {
      span.end();
    }
  }
}
