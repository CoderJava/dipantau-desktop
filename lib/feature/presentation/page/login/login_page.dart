import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/core/util/string_extension.dart';
import 'package:dipantau_desktop_client/core/util/widget_helper.dart';
import 'package:dipantau_desktop_client/feature/data/model/login/login_body.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/login/login_bloc.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/home/home_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/register/register_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_primary_button.dart';
import 'package:dipantau_desktop_client/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  static const routePath = '/login';
  static const routeName = 'login';

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginBloc = sl<LoginBloc>();
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final helper = sl<Helper>();
  final valueNotifierShowPassword = ValueNotifier<bool>(false);
  final formState = GlobalKey<FormState>();
  final widgetHelper = WidgetHelper();

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isLoading,
      child: BlocProvider<LoginBloc>(
        create: (context) => loginBloc,
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            isLoading = state is LoadingLoginState;
            if (state is FailureLoginState) {
              final errorMessage = state.errorMessage;
              widgetHelper.showSnackBar(context, errorMessage.hideResponseCode());
            } else if (state is SuccessSubmitLoginState) {
              context.goNamed(HomePage.routeName);
            }
          },
          child: Scaffold(
            body: Padding(
              padding: EdgeInsets.all(helper.getDefaultPaddingLayout),
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
            /*final email = controllerEmail.text.trim();
            context.pushNamed(
              ResetPasswordPage.routeName,
              queryParams: {
                'email': email,
              },
            );*/
            // TODO: Buat fitur forgot password
            widgetHelper.showSnackBar(context, 'coming_soon'.tr());
          },
          child: Text(
            'forgot_password'.tr(),
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }

  Widget buildWidgetButtonSignIn() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
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
      },
    );
  }

  void doSignIn() {
    if (formState.currentState!.validate()) {
      final username = controllerEmail.text.trim();
      final password = controllerPassword.text.trim();
      final body = LoginBody(
        username: username,
        password: password,
      );
      loginBloc.add(SubmitLoginEvent(body: body));
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
