part of autocloud.markhor;

class MarkhorOverviewPage extends StatefulWidget {
  const MarkhorOverviewPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => MarkhorOverviewPageState();
}

class MarkhorOverviewPageState extends PageScaffoldState<MarkhorOverviewPage> {
  MarkhorOverviewPageState() : super(pageId: PageViewId.markhor);

  @override
  Widget build(BuildContext context) {
    return ACPGlobalScaffold(
      child: SizedBox(),
    );
  }
}
