import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/splash/splash_page.dart';
import 'package:dipantau_desktop_client/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
  }) {
    return InputDecoration(
      labelText: labelText,
      isDense: true,
      border: const OutlineInputBorder(),
      suffixIcon: suffixIcon,
      hintText: hintText,
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
}
