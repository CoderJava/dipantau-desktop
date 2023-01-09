import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/register/register_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_primary_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  static const routePath = '/login';
  static const routeName = 'login';

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final helper = Helper();

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
            children: [
              Text(
                'login'.tr(),
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(height: 8),
              Text(
                'subtitle_login'.tr(),
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      color: Colors.grey,
                    ),
              ),
              const SizedBox(height: 24),
              buildWidgetTextFieldEmail(),
              const SizedBox(height: 24),
              buildWidgetTextFieldPassword(),
              const SizedBox(height: 8),
              buildWidgetResetPassword(),
              const SizedBox(height: 24),
              buildWidgetButtonSignIn(),
              const SizedBox(height: 24),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'dont_have_an_account'.tr(),
                  ),
                  InkWell(
                    onTap: () {
                      context.push(RegisterPage.routePath);
                    },
                    child: Text(
                      'Register now for free',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row buildWidgetResetPassword() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            // TODO: Buat fitur reset password
          },
          child: Text(
            'reset_password'.tr(),
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }

  SizedBox buildWidgetButtonSignIn() {
    return SizedBox(
      width: double.infinity,
      child: WidgetPrimaryButton(
        onPressed: () {
          // TODO: Buat fitur login
        },
        child: Text(
          'sign_in'.tr(),
        ),
      ),
    );
  }

  TextFormField buildWidgetTextFieldPassword() {
    return TextFormField(
      controller: controllerPassword,
      decoration: InputDecoration(
        labelText: 'password'.tr(),
        isDense: true,
        border: const OutlineInputBorder(),
      ),
      obscureText: true,
    );
  }

  TextFormField buildWidgetTextFieldEmail() {
    return TextFormField(
      controller: controllerEmail,
      decoration: InputDecoration(
        labelText: 'email'.tr(),
        isDense: true,
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}
