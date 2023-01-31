import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/core/util/widget_helper.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/home/home_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/register/register_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/reset_password/reset_password_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_primary_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final valueNotifierShowPassword = ValueNotifier<bool>(false);
  final formState = GlobalKey<FormState>();
  final widgetHelper = WidgetHelper();

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isLoading,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: double.infinity,
            child: Form(
              key: formState,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'login'.tr(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'subtitle_login'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
            final email = controllerEmail.text.trim();
            context.pushNamed(
              ResetPasswordPage.routeName,
              queryParams: {
                'email': email,
              },
            );
          },
          child: Text(
            'forgot_password'.tr(),
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
        onPressed: doSignIn,
        isLoading: isLoading,
        child: Text(
          'sign_in'.tr(),
        ),
      ),
    );
  }

  Future<void> doSignIn() async {
    if (formState.currentState!.validate()) {
      setState(() => isLoading = true);
      final email = controllerEmail.text.trim();
      final password = controllerPassword.text.trim();
      try {
        final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        final user = userCredential.user;
        if (user == null) {
          if (mounted) {
            widgetHelper.showSnackBar(context, 'Error: User is null');
          }
          return;
        }
        final isEmailVerified = user.emailVerified;
        if (!isEmailVerified) {
          await user.sendEmailVerification();
          await FirebaseAuth.instance.signOut();
          if (mounted) {
            widgetHelper.showSnackBar(context, 'please_verify_your_email'.tr());
          }
        } else {
          if (mounted) {
            context.goNamed(HomePage.routeName);
          }
        }
      } on FirebaseAuthException catch (e) {
        final errorCode = e.code;
        var errorMessage = e.message ?? 'sign_in_failed'.tr();
        if (errorCode == 'invalid-email') {
          errorMessage = 'invalid_email'.tr();
        } else if (errorCode == 'user-disabled') {
          errorMessage = 'user_disabled'.tr();
        } else if (errorCode == 'user-not-found') {
          errorMessage = 'user_not_found'.tr();
        } else if (errorCode == 'wrong-password') {
          errorMessage = 'wrong_password_login'.tr();
        }
        widgetHelper.showSnackBar(context, errorMessage);
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  Widget buildWidgetTextFieldPassword() {
    return ValueListenableBuilder<bool>(
      valueListenable: valueNotifierShowPassword,
      builder: (BuildContext context, bool isShowPassword, _) {
        return TextFormField(
          controller: controllerPassword,
          decoration: widgetHelper.setDefaultTextFieldDecoration(
            labelText: 'password'.tr(),
            suffixIcon: InkWell(
              onTap: () {
                valueNotifierShowPassword.value = !valueNotifierShowPassword.value;
              },
              child: Icon(isShowPassword ? Icons.visibility : Icons.visibility_off),
            ),
          ),
          obscureText: !isShowPassword,
          textInputAction: TextInputAction.go,
          onFieldSubmitted: (_) {
            doSignIn();
          },
          validator: (value) {
            return value == null || value.isEmpty ? 'password_is_required'.tr() : null;
          },
        );
      },
    );
  }

  TextFormField buildWidgetTextFieldEmail() {
    return TextFormField(
      controller: controllerEmail,
      decoration: widgetHelper.setDefaultTextFieldDecoration(
        labelText: 'email'.tr(),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value != null) {
          if (value.isEmpty) {
            return 'invalid_email'.tr();
          } else {
            final isEmailValid = helper.checkValidationEmail(value);
            return !isEmailValid ? 'invalid_email'.tr() : null;
          }
        }
        return null;
      },
      textInputAction: TextInputAction.next,
    );
  }
}
