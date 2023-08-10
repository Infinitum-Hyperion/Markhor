part of markhor;

class MarkhorWorkstation {
  /// A benefit of using a [MarkhorWorkstation] is that it can initialise all the
  /// components for you. If you create [WorkstationComponent]s without providing
  /// an overall workstation, you'll have to figure out the async initialisers for
  /// each component and await them individually.
  final List<Future> _asyncInitialisations = [];
  late final Observatory observatory;
  final List<WorkstationNode> nodes = [];
  final List<WorkstationAgent> agents = [];

  Future<void> initAsyncComponents() async =>
      await Future.wait(_asyncInitialisations);
}
