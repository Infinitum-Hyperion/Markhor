part of markhor.ui.panes;

class ImageRendererPane extends StatefulWidget {
  final double width;
  final double height;
  final Stream<Image> imageByteStream;

  const ImageRendererPane({
    required this.width,
    required this.height,
    required this.imageByteStream,
    super.key,
  });
  @override
  State<StatefulWidget> createState() => ImageRendererPaneState();
}

class ImageRendererPaneState extends State<ImageRendererPane> with PaneStyling {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return paneStyle(
      title: 'Image',
      primaryColor: ACPColor.purple,
      width: widget.width,
      child: StreamBuilder(
        stream: widget.imageByteStream,
        builder: (ctx, snapshot) => snapshot.hasData
            ? SizedBox(
                width: widget.width,
                height: widget.height,
                child: snapshot.data!,
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
