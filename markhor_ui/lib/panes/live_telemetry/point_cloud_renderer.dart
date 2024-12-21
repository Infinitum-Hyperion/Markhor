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
  double vs = 0, ms = 0, us = 0;
  late final DiTreDiController controller;

  @override
  void initState() {
    controller = DiTreDiController()
      ..userScale = 10
      ..rotationX = -90
      ..rotationY = 360
      ..rotationZ = 90
      ..userScale = 4;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return paneStyle(
      title: 'Point Cloud ($vs, $ms, $us)',
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
                    controller: controller,
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
