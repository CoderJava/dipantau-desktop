import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
  }) {
    return InputDecoration(
      labelText: labelText,
      isDense: true,
      border: const OutlineInputBorder(),
      suffixIcon: suffixIcon,
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
                Navigator.pop(context);
              },
              child: Text('ok'.tr()),
            ),
          ],
        );
      },
    );
  }
}
