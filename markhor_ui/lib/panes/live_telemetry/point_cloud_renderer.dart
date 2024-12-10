part of markhor.ui.panes;

class PointCloudRendererPane extends StatefulWidget {
  final double width;
  final double height;
  final Stream<List<Vector3>> pointsStream;

  const PointCloudRendererPane({
    required this.width,
    required this.height,
    required this.pointsStream,
    super.key,
  });
  @override
  State<StatefulWidget> createState() => PointCloudRendererPaneState();
}

class PointCloudRendererPaneState extends State<PointCloudRendererPane>
    with PaneStyling {
  final DiTreDiController controller = DiTreDiController()..userScale = 10;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return paneStyle(
      title: 'Point Cloud',
      primaryColor: ACPColor.purple,
      width: widget.width,
      child: StreamBuilder(
        stream: widget.pointsStream,
        builder: (ctx, snapshot) => snapshot.hasData
            ? SizedBox(
                width: widget.width,
                height: widget.height,
                child: DiTreDiDraggable(
                  controller: controller,
                  child: DiTreDi(
                    figures: [
                      for (final point in snapshot.data!)
                        Point3D(
                          point,
                          color: Colors.red,
                        ),
                    ],
                  ),
                ),
              )
            : const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
