import 'dart:io';

import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/splash/splash_page.dart';
import 'package:dipantau_desktop_client/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

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
}
