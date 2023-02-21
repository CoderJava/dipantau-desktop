import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class PlatformChannelHelper {
  // Method channel
  final _methodChannelName = 'dipantau/channel';
  final _keyInvokeMethodQuitApp = 'quit_app';
  final _keyInvokeMethodTakeScreenshot = 'take_screenshot';

  // Event channel
  final _eventChannelName = 'dipantau/event';
  final _keyEventChannelActivityListener = 'activity_listener';

  late MethodChannel _methodChannel;
  late EventChannel _eventChannel;

  PlatformChannelHelper() {
    _methodChannel = MethodChannel(_methodChannelName);
    _eventChannel = EventChannel(_eventChannelName);
  }

  void doQuitApp() async {
    try {
      await _methodChannel.invokeMethod(_keyInvokeMethodQuitApp);
    } catch (error) {
      debugPrint('Error quit app: $error');
    }
  }

  Future<List<String?>> doTakeScreenshot() async {
    final listPathScreenshots = <String?>[];
    try {
      final directory = await getApplicationDocumentsDirectory();
      final directoryPath = '${directory.path}/dipantau';
      final isDirectoryExists = checkDirectory(directoryPath);
      if (isDirectoryExists) {
        final listScreenshots = await _methodChannel.invokeMethod<List?>(
          _keyInvokeMethodTakeScreenshot,
          {
            'path': directoryPath,
          },
        );
        if (listScreenshots != null) {
          listPathScreenshots.addAll(listScreenshots.map((e) {
            var strValue = e as String?;
            if (strValue == null || strValue.isEmpty) {
              return null;
            }
            if (strValue.toLowerCase().contains('user')) {
              final startIndex = strValue.toLowerCase().indexOf('user');
              if (startIndex == -1) {
                return strValue;
              } else {
                strValue = strValue.substring(startIndex);
              }
            }
            return strValue;
          }).toList());
        }
      }
    } catch (error) {
      debugPrint('Error do take screenshot: $error');
    }
    return listPathScreenshots;
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

  void setActivityListener() {
    try {
      _methodChannel.invokeMethod(_keyEventChannelActivityListener);
    } catch (error) {
      debugPrint('Error set activity listener: $error');
    }
  }

  Stream startEventChannel() {
    return _eventChannel.receiveBroadcastStream();
  }
}
