import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/core/util/widget_helper.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/reset_password_success/reset_password_success_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordPage extends StatefulWidget {
  static const routePath = '/reset-password';
  static const routeName = 'reset-password';

  final String? email;

  const ResetPasswordPage({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final formState = GlobalKey<FormState>();
  final helper = Helper();
  final widgetHelper = WidgetHelper();
  final controllerEmail = TextEditingController();

  var isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.email != null) {
      controllerEmail.text = widget.email!;
    }
  }

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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'forgot_password'.tr(),
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'subtitle_reset_password'.tr(),
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  buildWidgetTextFieldEmail(),
                  const SizedBox(height: 24),
                  buildWidgetButtonResetPassword(),
                  const SizedBox(height: 24),
                  buildWidgetBackToLogin(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildWidgetTextFieldEmail() {
    return TextFormField(
      controller: controllerEmail,
      decoration: InputDecoration(
        labelText: 'email'.tr(),
        isDense: true,
        border: const OutlineInputBorder(),
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
      textInputAction: TextInputAction.go,
      onFieldSubmitted: (_) {
        doResetPassword();
      },
    );
  }

  Widget buildWidgetBackToLogin() {
    return TextButton(
      onPressed: () => context.pop(),
      style: TextButton.styleFrom(
        foregroundColor: Colors.grey[700],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.keyboard_backspace,
          ),
          const SizedBox(width: 8),
          Text(
            'back_to_login'.tr(),
          ),
        ],
      ),
    );
  }

  Widget buildWidgetButtonResetPassword() {
    return SizedBox(
      width: double.infinity,
      child: WidgetPrimaryButton(
        onPressed: doResetPassword,
        isLoading: isLoading,
        child: Text(
          'reset_password'.tr(),
        ),
      ),
    );
  }
  
  Future<void> doResetPassword() async {
    if (formState.currentState!.validate()) {
      setState(() => isLoading = true);
      final email = controllerEmail.text.trim();
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        if (mounted) {
          context.goNamed(
            ResetPasswordSuccessPage.routeName,
            queryParams: {
              'email': email,
            },
          );
        }
      } on FirebaseAuthException catch (e) {
        final errorCode = e.code;
        var errorMessage = e.message ?? 'reset_password_failed'.tr();
        if (errorCode == 'auth/invalid-email') {
          errorMessage = 'invalid_email'.tr();
        } else if (errorCode == 'auth/missing-android-pkg-name') {
          errorMessage = 'Error: Missing android package name';
        } else if (errorCode == 'auth/missing-continue-uri') {
          errorMessage = 'Error: Missing continue URI';
        } else if (errorCode == 'auth/missing-ios-bundle-id') {
          errorMessage = 'Error: Missing iOS bundle ID';
        } else if (errorCode == 'auth/invalid-continue-uri') {
          errorMessage = 'Error: Invalid continue URI';
        } else if (errorCode == 'auth/unauthorized-continue-uri') {
          errorMessage = 'Error: Unauthorized continue URI';
        } else if (errorCode == 'auth/user-not-found') {
          errorMessage = 'user_not_found'.tr();
        }
        widgetHelper.showSnackBar(context, errorMessage);
      } finally {
        setState(() => isLoading = false);
      }
    }
  }
}
