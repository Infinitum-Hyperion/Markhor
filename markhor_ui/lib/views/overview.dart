part of autocloud.markhor;

class MarkhorOverviewPage extends StatefulWidget {
  const MarkhorOverviewPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => MarkhorOverviewPageState();
}

class MarkhorOverviewPageState extends ViewScaffoldState<MarkhorOverviewPage> {
  MarkhorOverviewPageState()
      : super(
          pageId: PageViewId.markhor,
          viewId: PageViewId.mk_workstation,
        );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ACPGlobalScaffold(
      child: SizedBox(),
    );
  }
}
