import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/login/login_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_icon_circle.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_primary_button.dart';
import 'package:dipantau_desktop_client/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordSuccessPage extends StatelessWidget {
  static const routePath = '/reset-password-success';
  static const routeName = 'reset-password-success';

  ResetPasswordSuccessPage({
    super.key,
  });

  final helper = sl<Helper>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(helper.getDefaultPaddingLayout),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const WidgetIconCircle(iconData: Icons.email_outlined),
              const SizedBox(height: 24),
              Text(
                'reset_password_successfully'.tr(),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'subtitle_reset_password_successfully'.tr(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              WidgetPrimaryButton(
                onPressed: () => context.goNamed(LoginPage.routeName),
                child: Text('back_to_login'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
