library autocloud.markhor;

import 'package:flutter/material.dart';
import 'package:autocloud_ui/design_system/design_system.dart';

part './views/overview.dart';
part './views/live_telemetry.dart';

const runMarkhorMain = true;
void main(List<String> args) {
  if (!runMarkhorMain) return;
  runApp(MarkhorOverviewPage());
}
