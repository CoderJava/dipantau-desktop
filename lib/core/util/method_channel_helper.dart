import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MethodChannelHelper {
  final channelName = 'dipantau/channel';
  final keyInvokeMethodQuitApp = 'quit_app';

  late MethodChannel methodChannel;

  MethodChannelHelper() {
    methodChannel = MethodChannel(channelName);
  }

  void doQuitApp() async {
    try {
      await methodChannel.invokeMethod(keyInvokeMethodQuitApp);
    } catch (error) {
      debugPrint('Error quit app: $error');
    }
  }
}