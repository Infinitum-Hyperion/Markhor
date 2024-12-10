library autocloud.markhor;

import 'package:autocloud_ui/utils/meta.dart';
import 'package:flutter/material.dart';
import 'package:autocloud_ui/design_system/design_system.dart';
import 'package:markhor_ui/panes/panes.dart';

part './views/overview.dart';
part './views/live_telemetry.dart';

void main(List<String> args) {
  runApp(
    MaterialApp(
      home: MarkhorLiveTelemetryView(),
    ),
  );
}
