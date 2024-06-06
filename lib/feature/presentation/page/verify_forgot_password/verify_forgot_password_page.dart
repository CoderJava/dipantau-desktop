import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/core/util/string_extension.dart';
import 'package:dipantau_desktop_client/core/util/widget_helper.dart';
import 'package:dipantau_desktop_client/feature/data/model/verify_forgot_password/verify_forgot_password_body.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/reset_password/reset_password_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/splash/splash_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_primary_button.dart';
import 'package:dipantau_desktop_client/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class VerifyForgotPasswordPage extends StatefulWidget {
  static const routePath = '/verify-forgot-password';
  static const routeName = 'verify-forgot-password';
  static const parameterEmail = 'email';

  final String email;

  const VerifyForgotPasswordPage({
    super.key,
    required this.email,
  });

  @override
  State<VerifyForgotPasswordPage> createState() => _VerifyForgotPasswordPageState();
}

class _VerifyForgotPasswordPageState extends State<VerifyForgotPasswordPage> {
  final forgotPasswordBloc = sl<ForgotPasswordBloc>();
  final formState = GlobalKey<FormState>();
  final helper = sl<Helper>();
  final widgetHelper = WidgetHelper();
  final controllerCode = TextEditingController();

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
      child: BlocProvider<ForgotPasswordBloc>(
        create: (context) => forgotPasswordBloc,
        child: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
          listener: (context, state) {
            setState(() => isLoading = state is LoadingForgotPasswordState);
            if (state is FailureForgotPasswordState) {
              final errorMessage = state.errorMessage.convertErrorMessageToHumanMessage();
              widgetHelper.showSnackBar(context, errorMessage.hideResponseCode());
            } else if (state is SuccessVerifyForgotPasswordState) {
              final code = state.code;
              context.goNamed(
                ResetPasswordPage.routeName,
                extra: {
                  ResetPasswordPage.parameterCode: code,
                },
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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'verify_forgot_password'.tr(),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'subtitle_verify_forgot_password'.tr(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  widget.email,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[900],
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 24),
                buildWidgetTextFieldCode(),
                const SizedBox(height: 24),
                buildWidgetButtonVerify(),
                const SizedBox(height: 24),
                buildWidgetBackToLogin(),
              ],
            )),
      ),
    );
  }

  Widget buildWidgetTextFieldCode() {
    return TextFormField(
      controller: controllerCode,
      decoration: widgetHelper.setDefaultTextFieldDecoration(
        labelText: 'code'.tr(),
      ),
      keyboardType: TextInputType.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textInputAction: TextInputAction.go,
      onFieldSubmitted: (_) {
        doVerificationCode();
      },
      validator: (value) {
        return value == null || value.isEmpty ? 'enter_a_code'.tr() : null;
      },
    );
  }

  void doVerificationCode() {
    if (formState.currentState!.validate()) {
      final code = controllerCode.text.trim();
      final body = VerifyForgotPasswordBody(
        code: code,
      );
      forgotPasswordBloc.add(
        SubmitVerifyForgotPasswordEvent(
          body: body,
        ),
      );
    }
  }

  Widget buildWidgetButtonVerify() {
    return SizedBox(
      width: double.infinity,
      child: WidgetPrimaryButton(
        onPressed: doVerificationCode,
        isLoading: isLoading,
        child: Text(
          'verify'.tr(),
        ),
      ),
    );
  }

  Widget buildWidgetBackToLogin() {
    return TextButton(
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
    );
  }
}
