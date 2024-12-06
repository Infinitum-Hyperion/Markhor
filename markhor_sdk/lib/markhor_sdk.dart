library markhor.sdk;

import 'dart:convert';
import 'dart:io';

part './communication/lightweight_communication_bridge.dart';

void main(List<String> args) {
  LightweightCommunicationBridge()..initServer();
}
