import 'package:dipantau_desktop_client/feature/presentation/page/login/login_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_primary_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterSuccessPage extends StatelessWidget {
  static const routePath = '/register-success';
  static const routeName = 'register-success';

  final String email;

  const RegisterSuccessPage({
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
                  Icons.check,
                  color: Theme.of(context).primaryColor,
                  size: 32,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'create_account_successfully'.tr(),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'subtitle_create_account_successfully'.tr(
                  args: [
                    email,
                  ],
                ),
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
