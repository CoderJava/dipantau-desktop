import 'package:dipantau_desktop_client/feature/presentation/page/login/login_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordSuccessPage extends StatelessWidget {
  static const routePath = '/reset-password-success';
  static const routeName = 'reset-password-success';

  final String email;

  const ResetPasswordSuccessPage({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.email_outlined,
                  color: Theme.of(context).primaryColor,
                  size: 32,
                ),
              ),
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
              Text(
                email,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
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
