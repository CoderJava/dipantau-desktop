import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/core/util/string_extension.dart';
import 'package:dipantau_desktop_client/core/util/widget_helper.dart';
import 'package:dipantau_desktop_client/feature/data/model/forgot_password/forgot_password_body.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/verify_forgot_password/verify_forgot_password_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_primary_button.dart';
import 'package:dipantau_desktop_client/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordPage extends StatefulWidget {
  static const routePath = '/forgot-password';
  static const routeName = 'forgot-password';
  static const parameterEmail = 'email';

  final String? email;

  const ForgotPasswordPage({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formState = GlobalKey<FormState>();
  final helper = sl<Helper>();
  final widgetHelper = WidgetHelper();
  final controllerEmail = TextEditingController();
  final forgotPasswordBloc = sl<ForgotPasswordBloc>();

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
      child: BlocProvider<ForgotPasswordBloc>(
        create: (context) => forgotPasswordBloc,
        child: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
          listener: (context, state) {
            setState(() => isLoading = state is LoadingForgotPasswordState);
            if (state is FailureForgotPasswordState) {
              final errorMessage = state.errorMessage.convertErrorMessageToHumanMessage();
              widgetHelper.showSnackBar(context, errorMessage.hideResponseCode());
            } else if (state is SuccessForgotPasswordState) {
              final email = state.email;
              context.goNamed(
                VerifyForgotPasswordPage.routeName,
                extra: {
                  VerifyForgotPasswordPage.parameterEmail: email,
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
                'forgot_password'.tr(),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'subtitle_forgot_password'.tr(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
              const SizedBox(height: 24),
              buildWidgetTextFieldEmail(),
              const SizedBox(height: 24),
              buildWidgetButtonForgotPassword(),
              const SizedBox(height: 24),
              buildWidgetBackToLogin(),
            ],
          ),
        ),
      ),
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
      textInputAction: TextInputAction.go,
      onFieldSubmitted: (_) {
        doForgotPassword();
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

  Widget buildWidgetButtonForgotPassword() {
    return SizedBox(
      width: double.infinity,
      child: WidgetPrimaryButton(
        onPressed: doForgotPassword,
        isLoading: isLoading,
        child: Text(
          'continue'.tr(),
        ),
      ),
    );
  }

  Future<void> doForgotPassword() async {
    if (formState.currentState!.validate()) {
      final email = controllerEmail.text.trim();
      final body = ForgotPasswordBody(
        email: email,
      );
      forgotPasswordBloc.add(
        SubmitForgotPasswordEvent(
          body: body,
        ),
      );
    }
  }
}
