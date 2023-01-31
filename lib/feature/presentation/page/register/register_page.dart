import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/core/util/validator_password.dart';
import 'package:dipantau_desktop_client/core/util/widget_helper.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/register_success/register_success_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_primary_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  static const routePath = '/register';
  static const routeName = 'register';

  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final controllerFullname = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final formState = GlobalKey<FormState>();
  final helper = Helper();
  final validatorPassword = ValidatorPassword();
  final widgetHelper = WidgetHelper();

  var valueNotifierShowPassword = ValueNotifier<bool>(false);
  var isLoadingButton = false;
  var isIgnorePointer = false;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isIgnorePointer,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: double.infinity,
            child: Form(
              key: formState,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'register'.tr(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'subtitle_register'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  const SizedBox(height: 24),
                  buildWidgetTextFieldFullName(),
                  const SizedBox(height: 24),
                  buildWidgetTextFieldEmail(),
                  const SizedBox(height: 24),
                  buildWidgetTextFieldPassword(),
                  const SizedBox(height: 24),
                  buildWidgetButtonRegister(),
                  const SizedBox(height: 24),
                  buildWidgetButtonBackToLogin(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildWidgetTextFieldFullName() {
    return TextFormField(
      controller: controllerFullname,
      decoration: InputDecoration(
        labelText: 'full_name'.tr(),
        isDense: true,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        return value == null || value.isEmpty ? 'full_name_is_required'.tr() : null;
      },
      textInputAction: TextInputAction.next,
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
      textInputAction: TextInputAction.next,
    );
  }

  Widget buildWidgetTextFieldPassword() {
    return ValueListenableBuilder<bool>(
      valueListenable: valueNotifierShowPassword,
      builder: (BuildContext context, bool isShowPassword, _) {
        return TextFormField(
          controller: controllerPassword,
          decoration: InputDecoration(
            labelText: 'password'.tr(),
            isDense: true,
            border: const OutlineInputBorder(),
            suffixIcon: InkWell(
              onTap: () {
                valueNotifierShowPassword.value = !valueNotifierShowPassword.value;
              },
              child: Icon(isShowPassword ? Icons.visibility : Icons.visibility_off),
            ),
          ),
          obscureText: !isShowPassword,
          textInputAction: TextInputAction.go,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'password_is_required'.tr();
            } else {
              final isPasswordLengthValid = validatorPassword.hasMinLength(value, 8);
              final isPasswordLowerCaseValid = validatorPassword.hasMinLowerCaseChar(value, 1);
              final isPasswordUpperCaseValid = validatorPassword.hasMinUpperCaseChar(value, 1);
              final isPasswordNumericValid = validatorPassword.hasMinNumericChar(value, 1);
              final isPasswordSpecialCharacterValid = validatorPassword.hasMinSpecialChar(value, 1);
              if (!isPasswordLengthValid) {
                return 'at_least_8_characters'.tr();
              }
              if (!isPasswordLowerCaseValid) {
                return 'at_least_contain_a_lower_case'.tr();
              }
              if (!isPasswordUpperCaseValid) {
                return 'at_least_contain_a_upper_case'.tr();
              }
              if (!isPasswordNumericValid) {
                return 'at_least_contain_a_number'.tr();
              }
              if (!isPasswordSpecialCharacterValid) {
                return 'at_least_contain_a_symbol'.tr();
              }
              return null;
            }
          },
          onFieldSubmitted: (_) {
            doCreateAccount();
          },
        );
      },
    );
  }

  Widget buildWidgetButtonRegister() {
    return SizedBox(
      width: double.infinity,
      child: WidgetPrimaryButton(
        onPressed: doCreateAccount,
        isLoading: isLoadingButton,
        child: Text(
          'create_account'.tr(),
        ),
      ),
    );
  }

  Future<void> doCreateAccount() async {
    if (formState.currentState!.validate()) {
      try {
        setState(() {
          isIgnorePointer = true;
          isLoadingButton = true;
        });
        final email = controllerEmail.text.trim();
        final password = controllerPassword.text.trim();
        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await userCredential.user!.sendEmailVerification();
        await FirebaseAuth.instance.signOut();
        if (mounted) {
          context.goNamed(
            RegisterSuccessPage.routeName,
            queryParams: {
              'email': email,
            },
          );
        }
      } on FirebaseAuthException catch (e) {
        final errorCode = e.code;
        var errorMessage = e.message ?? 'failed_create_account'.tr();
        if (errorCode == 'email-already-in-use') {
          errorMessage = 'email_already_in_use'.tr();
        } else if (errorCode == 'invalid-email') {
          errorMessage = 'invalid_email'.tr();
        } else if (errorCode == 'operation-not-allowed') {
          errorMessage = 'operation_not_allowed'.tr();
        } else if (errorCode == 'weak-password') {
          errorMessage = 'weak_password'.tr();
        }
        widgetHelper.showSnackBar(
          context,
          errorMessage,
        );
      } finally {
        setState(() {
          isIgnorePointer = false;
          isLoadingButton = false;
        });
      }
    }
  }

  Widget buildWidgetButtonBackToLogin() {
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
}
