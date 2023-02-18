import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class MethodChannelHelper {
  final channelName = 'dipantau/channel';
  final keyInvokeMethodQuitApp = 'quit_app';
  final keyInvokeMethodTakeScreenshot = 'take_screenshot';

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

  Future<void> doTakeScreenshot() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final directoryPath = '${directory.path}/dipantau';
      final isDirectoryExists = checkDirectory(directoryPath);
      if (isDirectoryExists) {
        await methodChannel.invokeMethod(
          keyInvokeMethodTakeScreenshot,
          {
            'path': directoryPath,
          },
        );
      }
    } catch (error) {
      debugPrint('Error do take screenshot: $error');
    }
  }

  bool checkDirectory(String pathDirectory) {
    final directory = Directory(pathDirectory);
    if (pathDirectory.isNotEmpty && !directory.existsSync()) {
      try {
        directory.createSync(recursive: true);
        return true;
      } catch (error) {
        debugPrint('Error create directory: $error');
        return false;
      }
    }
    return true;
  }
}