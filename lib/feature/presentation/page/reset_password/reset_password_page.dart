import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/core/util/password_validator.dart';
import 'package:dipantau_desktop_client/core/util/string_extension.dart';
import 'package:dipantau_desktop_client/core/util/widget_helper.dart';
import 'package:dipantau_desktop_client/feature/data/model/reset_password/reset_password_body.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/reset_password/reset_password_bloc.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/reset_password_success/reset_password_success_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/splash/splash_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_primary_button.dart';
import 'package:dipantau_desktop_client/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordPage extends StatefulWidget {
  static const routePath = '/reset-password';
  static const routeName = 'reset-password';
  static const parameterCode = 'code';

  final String code;

  const ResetPasswordPage({
    Key? key,
    required this.code,
  }) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final resetPasswordBloc = sl<ResetPasswordBloc>();
  final formState = GlobalKey<FormState>();
  final helper = sl<Helper>();
  final widgetHelper = WidgetHelper();
  final controllerPassword = TextEditingController();
  final passwordValidator = PasswordValidator();
  final valueNotifierShowPassword = ValueNotifier<bool>(false);
  final valueNotifierPasswordLength = ValueNotifier(false);
  final valueNotifierPasswordLowerCase = ValueNotifier(false);
  final valueNotifierPasswordUpperCase = ValueNotifier(false);
  final valueNotifierPasswordNumericChar = ValueNotifier(false);
  final valueNotifierPasswordSpecialChar = ValueNotifier(false);
  final valueNotifierEnableButton = ValueNotifier(false);

  var isLoading = false;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isLoading,
      child: BlocProvider<ResetPasswordBloc>(
        create: (context) => resetPasswordBloc,
        child: BlocListener<ResetPasswordBloc, ResetPasswordState>(
          listener: (context, state) {
            setState(() => isLoading = state is LoadingResetPasswordState);
            if (state is FailureResetPasswordState) {
              final errorMessage = state.errorMessage.convertErrorMessageToHumanMessage();
              widgetHelper.showSnackBar(context, errorMessage.hideResponseCode());
            } else if (state is SuccessResetPasswordState) {
              context.goNamed(
                ResetPasswordSuccessPage.routeName,
              );
            }
          },
          child: Scaffold(
            body: buildWidgetForm(),
          ),
        ),
      ),
    );
  }

  Widget buildWidgetForm() {
    return Padding(
      padding: EdgeInsets.all(helper.getDefaultPaddingLayout),
      child: SizedBox(
        width: double.infinity,
        child: Form(
          key: formState,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Center(
                child: Text(
                  'new_password'.tr(),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'subtitle_new_password'.tr(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              buildWidgetTextFieldNewPassword(),
              const SizedBox(height: 24),
              buildWidgetPasswordValidator(),
              const SizedBox(height: 24),
              buildWidgetButtonChange(),
              const SizedBox(height: 24),
              buildWidgetBackToLogin(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildWidgetButtonChange() {
    final widgetButton = ValueListenableBuilder(
      valueListenable: valueNotifierEnableButton,
      builder: (BuildContext context, bool isEnable, _) {
        return SizedBox(
          width: double.infinity,
          child: WidgetPrimaryButton(
            onPressed: isEnable ? doChangePassword : null,
            isLoading: isLoading,
            child: Text(
              'change'.tr(),
            ),
          ),
        );
      },
    );

    return BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
      builder: (context, state) {
        return widgetButton;
      },
    );
  }

  Widget buildWidgetBackToLogin() {
    return Center(
      child: TextButton(
        onPressed: () => context.goNamed(SplashPage.routeName),
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
      ),
    );
  }

  Widget buildWidgetTextFieldNewPassword() {
    return ValueListenableBuilder(
      valueListenable: valueNotifierShowPassword,
      builder: (BuildContext context, bool isShowPassword, _) {
        return TextFormField(
          controller: controllerPassword,
          decoration: widgetHelper.setDefaultTextFieldDecoration(
            labelText: 'create_new_password'.tr(),
            suffixIcon: InkWell(
              onTap: () {
                valueNotifierShowPassword.value = !valueNotifierShowPassword.value;
              },
              child: Icon(
                isShowPassword ? Icons.visibility : Icons.visibility_off,
              ),
            ),
          ),
          obscureText: !isShowPassword,
          textInputAction: TextInputAction.go,
          onFieldSubmitted: (_) {
            doChangePassword();
          },
          onChanged: (value) {
            doValidatePassword(value);
            doCheckEnableButton();
          },
        );
      },
    );
  }

  void doChangePassword() {
    final password = controllerPassword.text.trim();
    final body = ResetPasswordBody(
      code: widget.code,
      password: password,
    );
    resetPasswordBloc.add(
      SubmitResetPasswordEvent(
        body: body,
      ),
    );
  }

  Widget buildWidgetPasswordValidator() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ValueListenableBuilder(
          valueListenable: valueNotifierPasswordLength,
          builder: (BuildContext context, bool isValid, _) {
            return buildWidgetItemPasswordValidator(
              isValid,
              label: 'min_n_characters'.tr(args: ['8']),
            );
          },
        ),
        ValueListenableBuilder(
          valueListenable: valueNotifierPasswordLowerCase,
          builder: (BuildContext context, bool isValid, _) {
            return buildWidgetItemPasswordValidator(
              isValid,
              label: 'lowercase_letter'.tr(),
            );
          },
        ),
        ValueListenableBuilder(
          valueListenable: valueNotifierPasswordUpperCase,
          builder: (BuildContext context, bool isValid, _) {
            return buildWidgetItemPasswordValidator(
              isValid,
              label: 'uppercase_letter'.tr(),
            );
          },
        ),
        ValueListenableBuilder(
          valueListenable: valueNotifierPasswordNumericChar,
          builder: (BuildContext context, bool isValid, _) {
            return buildWidgetItemPasswordValidator(
              isValid,
              label: 'numeric_character'.tr(),
            );
          },
        ),
        ValueListenableBuilder(
          valueListenable: valueNotifierPasswordSpecialChar,
          builder: (BuildContext context, bool isValid, _) {
            return buildWidgetItemPasswordValidator(
              isValid,
              label: 'special_character'.tr(),
            );
          },
        ),
      ],
    );
  }

  Widget buildWidgetItemPasswordValidator(
    bool isValid, {
    required String label,
  }) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final primaryContainer = Theme.of(context).colorScheme.primaryContainer;
    final backgroundColor =
        isValid ? primaryContainer : Theme.of(context).colorScheme.onSecondaryContainer.withOpacity(.1);
    final foregroundColor = isValid ? primaryColor : Colors.grey;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isValid
              ? Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: FaIcon(
                    FontAwesomeIcons.check,
                    color: foregroundColor,
                    size: 14,
                  ),
                )
              : Container(),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: foregroundColor,
                ),
          ),
        ],
      ),
    );
  }

  void doValidatePassword(String value) {
    final isPasswordLengthValid = passwordValidator.hasMinLength(value, 8);
    if (isPasswordLengthValid != valueNotifierPasswordLength.value) {
      valueNotifierPasswordLength.value = isPasswordLengthValid;
    }

    final isPasswordLowerCaseValid = passwordValidator.hasMinLowerCaseChar(value, 1);
    if (isPasswordLowerCaseValid != valueNotifierPasswordLowerCase.value) {
      valueNotifierPasswordLowerCase.value = isPasswordLowerCaseValid;
    }

    final isPasswordUpperCaseValid = passwordValidator.hasMinUpperCaseChar(value, 1);
    if (isPasswordUpperCaseValid != valueNotifierPasswordUpperCase.value) {
      valueNotifierPasswordUpperCase.value = isPasswordUpperCaseValid;
    }

    final isPasswordNumericCharValid = passwordValidator.hasMinNumericChar(value, 1);
    if (isPasswordNumericCharValid != valueNotifierPasswordNumericChar.value) {
      valueNotifierPasswordNumericChar.value = isPasswordNumericCharValid;
    }

    final isPasswordSpecialCharValid = passwordValidator.hasMinSpecialChar(value, 1);
    if (isPasswordSpecialCharValid != valueNotifierPasswordSpecialChar.value) {
      valueNotifierPasswordSpecialChar.value = isPasswordSpecialCharValid;
    }
  }

  void doCheckEnableButton() {
    var isEnableTemp = false;
    final password = controllerPassword.text.trim();
    final passwordLengthValid = valueNotifierPasswordLength.value;
    final passwordLowerCaseValid = valueNotifierPasswordLowerCase.value;
    final passwordUpperCaseValid = valueNotifierPasswordUpperCase.value;
    final passwordNumericCharValid = valueNotifierPasswordNumericChar.value;
    final passwordSpecialCharValid = valueNotifierPasswordSpecialChar.value;
    if (password.isNotEmpty &&
        passwordLengthValid &&
        passwordLowerCaseValid &&
        passwordUpperCaseValid &&
        passwordNumericCharValid &&
        passwordSpecialCharValid) {
      isEnableTemp = true;
    }

    if (isEnableTemp != valueNotifierEnableButton.value) {
      valueNotifierEnableButton.value = isEnableTemp;
    }
  }
}
