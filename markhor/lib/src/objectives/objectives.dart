part of markhor;

class SystemGoals extends AutonomicElement {
  final List<ServiceLevelAgreement> agreements;

  const SystemGoals({
    required this.agreements,
    required super.elementId,
    required super.systemId,
  });
}

class ServiceLevelAgreement extends AutonomicElement {
  final String description;
  final List<ServiceLevelObjective> objectives;

  const ServiceLevelAgreement({
    required this.description,
    required this.objectives,
    required super.elementId,
    required super.systemId,
  });
}

class ServiceLevelObjective<T> extends AutonomicElement {
  final SystemParameter systemParameter;
  final T targetValue;

  const ServiceLevelObjective({
    required this.systemParameter,
    required this.targetValue,
    required super.elementId,
    required super.systemId,
  });
}
