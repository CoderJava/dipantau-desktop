import 'package:dipantau_desktop_client/core/util/enum/user_role.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/core/util/string_extension.dart';
import 'package:dipantau_desktop_client/core/util/validator_password.dart';
import 'package:dipantau_desktop_client/core/util/widget_helper.dart';
import 'package:dipantau_desktop_client/feature/data/model/sign_up/sign_up_body.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/sign_up/sign_up_bloc.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/register_success/register_success_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_primary_button.dart';
import 'package:dipantau_desktop_client/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  static const routePath = '/register';
  static const routeName = 'register';

  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final signUpBloc = sl<SignUpBloc>();
  final controllerFullname = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final formState = GlobalKey<FormState>();
  final helper = sl<Helper>();
  final validatorPassword = ValidatorPassword();
  final widgetHelper = WidgetHelper();

  var valueNotifierShowPassword = ValueNotifier<bool>(false);
  var isLoadingButton = false;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isLoadingButton,
      child: BlocProvider<SignUpBloc>(
        create: (context) => signUpBloc,
        child: BlocListener<SignUpBloc, SignUpState>(
          listener: (context, state) {
            isLoadingButton = state is LoadingSignUpState;
            if (state is FailureSignUpState) {
              final errorMessage = state.errorMessage;
              widgetHelper.showSnackBar(context, errorMessage.hideResponseCode());
            } else if (state is SuccessSubmitSignUpState) {
              context.goNamed(
                RegisterSuccessPage.routeName,
                queryParameters: {
                  'email': state.response.email ?? '-',
                },
              );
            }
          },
          child: Scaffold(
            body: SizedBox(
              width: double.infinity,
              child: Form(
                key: formState,
                child: ListView(
                  padding: EdgeInsets.all(helper.getDefaultPaddingLayout),
                  children: [
                    Center(
                      child: Text(
                        'register'.tr(),
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'subtitle_register'.tr(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                        textAlign: TextAlign.center,
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
      ),
    );
  }

  Widget buildWidgetTextFieldFullName() {
    return TextFormField(
      controller: controllerFullname,
      decoration: widgetHelper.setDefaultTextFieldDecoration(
        labelText: 'full_name'.tr(),
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
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
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
      },
    );
  }

  void doCreateAccount() {
    if (formState.currentState!.validate()) {
      final name = controllerFullname.text.trim();
      final email = controllerEmail.text.trim();
      final password = controllerPassword.text.trim();
      signUpBloc.add(
        SubmitSignUpEvent(
          body: SignUpBody(
            name: name,
            email: email,
            password: password,
            userRole: UserRole.employee,
          ),
        ),
      );
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
