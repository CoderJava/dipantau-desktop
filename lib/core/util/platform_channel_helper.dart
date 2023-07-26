import 'dart:io';
import 'dart:math';

import 'package:dipantau_desktop_client/core/util/enum/global_variable.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/core/util/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlatformChannelHelper {
  // Method channel
  final _methodChannelName = 'dipantau/channel';
  final _keyInvokeMethodQuitApp = 'quit_app';
  final _keyInvokeMethodTakeScreenshot = 'take_screenshot';
  final _keyInvokeMethodCheckPermissionScreenRecording = 'check_permission_screen_recording';
  final _keyInvokeMethodCheckPermissionAccessibility = 'check_permission_accessibility';

  // Event channel
  final _eventChannelName = 'dipantau/event';
  final _keyEventChannelActivityListener = 'activity_listener';

  late MethodChannel _methodChannel;
  late EventChannel _eventChannel;
  final random = Random();

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
      final directoryPath = await WidgetHelper().getDirectoryApp('screenshot');
      final directory = Directory(directoryPath);
      final isDirectoryExists = directory.existsSync();

      var userId = sharedPreferencesManager.getString(SharedPreferencesManager.keyUserId) ?? '';
      if (userId.isEmpty) {
        userId = random.nextInt(100).toString();
      }
      final strRandomNumber = random.nextInt(100).toString();

      if (isDirectoryExists) {
        final listScreenshots = await _methodChannel.invokeMethod<List?>(
          _keyInvokeMethodTakeScreenshot,
          {
            'path': directoryPath,
            'user_id': userId,
            'random_number': strRandomNumber,
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

            if (!strValue.startsWith('/')) {
              strValue = '/$strValue';
            }
            if (strValue.endsWith('/')) {
              strValue = strValue.substring(0, strValue.length - 1);
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

  Future<bool?> checkPermissionScreenRecording() async {
    try {
      final result = await _methodChannel.invokeMethod<bool>(_keyInvokeMethodCheckPermissionScreenRecording);
      return result;
    } catch (error) {
      debugPrint('Error check permission screen recording: $error');
      return false;
    }
  }

  Future<bool?> checkPermissionAccessibility() async {
    try {
      final result = await _methodChannel.invokeMethod<bool>(_keyInvokeMethodCheckPermissionAccessibility);
      return result;
    } catch (error) {
      debugPrint('Error check permission accessibility: $error');
      return false;
    }
  }
}
