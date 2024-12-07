part of autocloud.markhor;

class MarkhorLiveTelemetryView extends StatefulWidget {
  const MarkhorLiveTelemetryView({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => MarkhorLiveTelemetryViewState();
}

class MarkhorLiveTelemetryViewState
    extends ViewScaffoldState<MarkhorLiveTelemetryView> {
  MarkhorLiveTelemetryViewState() : super(viewId: PageViewId.liveTelemetry);

  @override
  Widget build(BuildContext context) {
    return ACPGlobalScaffold(
      child: SizedBox(),
    );
  }
}
