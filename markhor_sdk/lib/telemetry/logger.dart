part of markhor.sdk;

class Logger {
  final void Function(String msg) info;
  final void Function(String msg) warn;
  final void Function(String msg) error;

  const Logger({
    required this.info,
    required this.warn,
    required this.error,
  });
}
