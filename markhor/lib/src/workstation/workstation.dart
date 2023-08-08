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

  void binObservatory(Observatory observatory) {
    observatory = observatory;
  }

  void bindAgents(List<WorkstationAgent> agents) {
    for (WorkstationAgent agent in agents) {
      agent.workstation = this;
    }
  }

  void bindNodes(List<WorkstationNode> nodes) {
    for (WorkstationNode node in nodes) {
      node.workstation = this;
    }
  }

  Future<void> initAsyncComponents() async =>
      await Future.wait(_asyncInitialisations);
}
