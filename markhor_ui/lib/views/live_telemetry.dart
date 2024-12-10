part of autocloud.markhor;

class MarkhorLiveTelemetryView extends StatefulWidget {
  final Map<String, WidgetBuilder> viewModes;

  const MarkhorLiveTelemetryView({
    this.viewModes = const {},
    super.key,
  });

  @override
  State<StatefulWidget> createState() => MarkhorLiveTelemetryViewState();
}

class MarkhorLiveTelemetryViewState
    extends ViewScaffoldState<MarkhorLiveTelemetryView> {
  MarkhorLiveTelemetryViewState()
      : super(
          pageId: PageViewId.markhor,
          viewId: PageViewId.mk_liveTelemetry,
        );
  late final Map<String, WidgetBuilder> viewModes;
  String currentViewMode = 'super';

  Widget superViewMode(BuildContext context) {
    return Column(
      children: [],
    );
  }

  @override
  void initState() {
    viewModes = {'super': superViewMode}..addAll(widget.viewModes);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ACPGlobalScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Live Telemetry',
            style: ACPFont.viewTitle(
              const TextStyle(color: ACPColor.purple),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 20),
              SizedBox(
                width: 130,
                height: 80,
                child: DropdownButtonFormField<String>(
                  items: [
                    for (final viewMode in viewModes.keys)
                      DropdownMenuItem(
                        value: viewMode,
                        child: Text(viewMode),
                      ),
                  ],
                  onChanged: (newMode) {
                    setState(() {
                      if (newMode != null) currentViewMode = newMode;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            width:
                MediaQuery.of(context).size.width - CONST.navigationRailWidth,
            height: 600,
            child: viewModes[currentViewMode]!(context),
          ),
        ],
      ),
    );
  }
}
