import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/core/util/enum/global_variable.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/splash/splash_page.dart';
import 'package:dipantau_desktop_client/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';

class WidgetHelper {
  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  InputDecoration setDefaultTextFieldDecoration({
    String? labelText,
    Widget? suffixIcon,
    String? hintText,
    FloatingLabelBehavior? floatingLabelBehavior,
    Color? hoverColor,
    BoxConstraints? suffixIconConstraints,
    bool? filled,
    Color? fillColor,
  }) {
    return InputDecoration(
      labelText: labelText,
      isDense: true,
      border: const OutlineInputBorder(),
      suffixIcon: suffixIcon,
      suffixIconConstraints: suffixIconConstraints,
      hintText: hintText,
      floatingLabelBehavior: floatingLabelBehavior,
      hoverColor: hoverColor,
      filled: filled,
      fillColor: fillColor,
    );
  }

  Future<void> showDialog401(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'info'.tr(),
          ),
          content: Text(
            'session_expired'.tr(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final helper = sl<Helper>();
                helper.setLogout().then((_) => context.goNamed(SplashPage.routeName));
              },
              child: Text('ok'.tr()),
            ),
          ],
        );
      },
    );
  }

  void unfocus(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  Future<String> getDirectoryApp(String folderName) async {
    // Users/yudisetiawan/Library
    final libraryDirectory = await getLibraryDirectory();
    final directory = Directory('${libraryDirectory.path}/dipantau/$folderName');
    final directoryPath = directory.path;
    final isDirectoryExists = directory.existsSync();
    if (isDirectoryExists) {
      return directoryPath;
    }
    directory.createSync(recursive: true);
    return directoryPath;
  }

  void showDialogPermissionScreenRecording(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'title_screen_recording_mac'.tr(),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'description_screen_recording_mac'.tr(),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '\n${'note'.tr()}',
                    ),
                    TextSpan(
                      text: ' ${'note_description_permission'.tr()}',
                    ),
                  ],
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('ok'.tr()),
            ),
          ],
        );
      },
    );
  }

  void showDialogPermissionAccessibility(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'title_accessibility_mac'.tr(),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'description_accessibility_mac'.tr(),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '\n${'note'.tr()}',
                    ),
                    TextSpan(
                      text: ' ${'note_description_permission'.tr()}',
                    ),
                  ],
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('ok'.tr()),
            ),
          ],
        );
      },
    );
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load(path);

    final directoryPath = await getDirectoryApp('screenshot');
    var userId = sharedPreferencesManager.getString(SharedPreferencesManager.keyUserId) ?? '';
    final random = Random();
    if (userId.isEmpty) {
      userId = random.nextInt(100).toString();
    }
    final strRandomNumber = random.nextInt(100).toString();

    final now = DateTime.now();
    final timeInMillis = now.millisecondsSinceEpoch;
    final timeInSeconds = Duration(milliseconds: timeInMillis).inSeconds;
    final pathString = '${timeInSeconds}_${userId}_${strRandomNumber}_1.jpg';
    final file = File('$directoryPath/$pathString');

    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Future<bool> isNewUpdateAvailable() async {
    final response =
        await Dio().get('https://raw.githubusercontent.com/CoderJava/dipantau-desktop/main/dist/appcast.xml');
    final data = response.data;
    final document = XmlDocument.parse(data);
    final sparkleVersion = document.findAllElements('sparkle:version');
    if (sparkleVersion.isNotEmpty) {
      final element = sparkleVersion.first;
      final versionText = element.innerText;
      final newVersion = int.tryParse(versionText);
      if (newVersion != null) {
        final strBuildNumberLocal = packageInfo.buildNumber;
        final buildNumberLocal = int.tryParse(strBuildNumberLocal);
        if (buildNumberLocal != null) {
          return newVersion > buildNumberLocal;
        }
      }
    }
    return false;
  }
}
