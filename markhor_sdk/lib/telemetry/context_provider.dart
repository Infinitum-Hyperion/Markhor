part of markhor.sdk;

abstract class ContextProviderInterface {
  final AutocloudArtifact artifact;

  ContextProviderInterface({
    required this.artifact,
  });

  FutureOr<T> executeSpan<T>(
    String label,
    FutureOr<T> Function(Logger) method,
  );
}
