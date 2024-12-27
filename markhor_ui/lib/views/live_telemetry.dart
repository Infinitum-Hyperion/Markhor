part of autocloud.markhor;

class MarkhorLiveTelemetryView extends StatefulWidget {
  final Map<String, Function> viewModes;

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
    // This mapping is hacky, but required in order to decouple autocloud_sdk from Flutter-specific
    // dependencies so that it can be imported into Dart CLI scripts.
    viewModes = {'super': superViewMode}
      ..addAll(widget.viewModes.map((key, fn) => MapEntry(
            key,
            (BuildContext context) {
              return fn(context) as Widget;
            },
          )));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ACPGlobalScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 12,
              top: 12,
            ),
            child: Text(
              'Live Telemetry',
              style: ACPFont.viewTitle(
                const TextStyle(color: ACPColor.purple),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 12,
              top: 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 20),
                SizedBox(
                  width: 130,
                  height: 60,
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
          ),
          const SizedBox(height: 12),
          SizedBox(
            width:
                MediaQuery.of(context).size.width - CONST.navigationRailWidth,
            height: 575,
            child: viewModes[currentViewMode]!(context),
          ),
        ],
      ),
    );
  }
}
