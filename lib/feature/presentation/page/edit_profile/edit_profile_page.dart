import 'package:dipantau_desktop_client/core/util/enum/user_role.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/core/util/password_validator.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/core/util/string_extension.dart';
import 'package:dipantau_desktop_client/core/util/widget_helper.dart';
import 'package:dipantau_desktop_client/feature/data/model/update_user/update_user_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_profile/user_profile_response.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/user_profile/user_profile_bloc.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_custom_circular_progress_indicator.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_error.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_primary_button.dart';
import 'package:dipantau_desktop_client/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class EditProfilePage extends StatefulWidget {
  static const routePath = '/edit-profile';
  static const routeName = 'edit-profile';

  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final userProfileBloc = sl<UserProfileBloc>();
  final sharedPreferencesManager = sl<SharedPreferencesManager>();
  final widgetHelper = WidgetHelper();
  final controllerName = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerUserRole = TextEditingController();
  final helper = sl<Helper>();
  final formState = GlobalKey<FormState>();
  final passwordValidator = PasswordValidator();
  final valueNotifierShowPassword = ValueNotifier<bool>(false);
  final valueNotifierPasswordLength = ValueNotifier(false);
  final valueNotifierPasswordLowerCase = ValueNotifier(false);
  final valueNotifierPasswordUpperCase = ValueNotifier(false);
  final valueNotifierPasswordNumericChar = ValueNotifier(false);
  final valueNotifierPasswordSpecialChar = ValueNotifier(false);
  final valueNotifierEnableButtonSave = ValueNotifier(false);

  var isLoading = false;
  UserProfileResponse? userProfile;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    doLoadData();
    super.initState();
  }

  void doLoadData() {
    userProfileBloc.add(LoadDataUserProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'edit_profile'.tr(),
          ),
          centerTitle: false,
        ),
        body: BlocProvider(
          create: (context) => userProfileBloc,
          child: BlocListener<UserProfileBloc, UserProfileState>(
            listener: (context, state) {
              setState(() => isLoading = state is LoadingButtonUserProfileState);
              if (state is FailureUserProfileState) {
                final errorMessage = state.errorMessage;
                if (errorMessage.contains('401')) {
                  widgetHelper.showDialog401(context);
                  return;
                }
              } else if (state is FailureSnackBarUserProfileState) {
                final errorMessage = state.errorMessage.convertErrorMessageToHumanMessage();
                if (errorMessage.contains('401')) {
                  widgetHelper.showDialog401(context);
                  return;
                }
                widgetHelper.showSnackBar(context, errorMessage.hideResponseCode());
              } else if (state is SuccessLoadDataUserProfileState) {
                userProfile = state.response;
                var name = '';
                var userRole = '';
                if (userProfile != null) {
                  name = userProfile?.name ?? '';
                  final email = userProfile?.username ?? '';
                  userRole = userProfile?.role?.toName.tr() ?? '';
                  controllerName.text = name;
                  controllerEmail.text = email;
                  controllerUserRole.text = userRole;
                }
                updateProfileInLocal(name, userProfile?.role?.name ?? '');
                doCheckEnableButtonSave();
              } else if (state is SuccessUpdateDataUserProfileState) {
                widgetHelper.showSnackBar(
                  context,
                  'profile_updated_successfully'.tr(),
                );
                final body = state.body;
                final name = body.name;
                final userRole = body.userRole.name;
                updateProfileInLocal(name, userRole);
                context.pop();
              }
            },
            child: BlocBuilder<UserProfileBloc, UserProfileState>(
              buildWhen: (previousState, currentState) {
                return currentState is LoadingCenterUserProfileState ||
                    currentState is FailureUserProfileState ||
                    currentState is SuccessLoadDataUserProfileState ||
                    currentState is SuccessUpdateDataUserProfileState;
              },
              builder: (context, state) {
                if (state is LoadingCenterUserProfileState) {
                  return const WidgetCustomCircularProgressIndicator();
                } else if (state is FailureUserProfileState) {
                  final errorMessage = state.errorMessage;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: helper.getDefaultPaddingLayout),
                    child: WidgetError(
                      title: 'info'.tr(),
                      message: errorMessage,
                      onTryAgain: doLoadData,
                    ),
                  );
                }
                return buildWidgetForm();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildWidgetForm() {
    return Form(
      key: formState,
      child: ListView(
        padding: EdgeInsets.only(
          left: helper.getDefaultPaddingLayout,
          top: helper.getDefaultPaddingLayout,
          right: helper.getDefaultPaddingLayout,
          bottom: helper.getDefaultPaddingLayout,
        ),
        children: [
          buildWidgetTextField(
            controller: controllerName,
            label: 'name'.tr(),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            validator: (value) {
              return value == null || value.isEmpty ? 'name_is_required'.tr() : null;
            },
          ),
          const SizedBox(height: 24),
          buildWidgetTextField(
            controller: controllerEmail,
            label: 'email'.tr(),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            enabled: false,
            validator: (value) {
              if (value != null) {
                if (value.isEmpty) {
                  return 'email_is_required'.tr();
                } else {
                  final isEmailValid = helper.checkValidationEmail(value);
                  return !isEmailValid ? 'invalid_email'.tr() : null;
                }
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          buildWidgetTextField(
            controller: controllerUserRole,
            label: 'role'.tr(),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            enabled: false,
            validator: (value) {
              return value == null || value.isEmpty ? 'role_is_required'.tr() : null;
            },
          ),
          const SizedBox(height: 24),
          buildWidgetTextFieldPassword(),
          const SizedBox(height: 24),
          buildWidgetPasswordValidator(),
          const SizedBox(height: 24),
          buildWidgetButtonSave(),
        ],
      ),
    );
  }

  void updateProfileInLocal(String name, String userRole) {
    sharedPreferencesManager.putString(SharedPreferencesManager.keyFullName, name);
    sharedPreferencesManager.putString(SharedPreferencesManager.keyUserRole, userRole);
  }

  void doCheckEnableButtonSave() {
    var isEnableTemp = false;
    final name = controllerName.text.trim();
    final email = controllerEmail.text.trim();
    final userRole = controllerUserRole.text.trim();
    final password = controllerPassword.text.trim();
    final passwordLengthValid = valueNotifierPasswordLength.value;
    final passwordLowerCaseValid = valueNotifierPasswordLowerCase.value;
    final passwordUpperCaseValid = valueNotifierPasswordUpperCase.value;
    final passwordNumericCharValid = valueNotifierPasswordNumericChar.value;
    final passwordSpecialCharValid = valueNotifierPasswordSpecialChar.value;
    if (password.isEmpty) {
      // si user tidak ubah password lamanya
      if (name.isNotEmpty && email.isNotEmpty && userRole.isNotEmpty) {
        isEnableTemp = true;
      }
    } else {
      // si user mau ubah password lamanya
      if (name.isNotEmpty &&
          email.isNotEmpty &&
          userRole.isNotEmpty &&
          password.isNotEmpty &&
          passwordLengthValid &&
          passwordLowerCaseValid &&
          passwordUpperCaseValid &&
          passwordNumericCharValid &&
          passwordSpecialCharValid) {
        isEnableTemp = true;
      }
    }

    if (isEnableTemp != valueNotifierEnableButtonSave.value) {
      valueNotifierEnableButtonSave.value = isEnableTemp;
    }
  }

  Widget buildWidgetTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    FormFieldValidator<String>? validator,
    bool? enabled,
  }) {
    return TextFormField(
      controller: controller,
      decoration: widgetHelper.setDefaultTextFieldDecoration(
        labelText: label,
      ),
      keyboardType: keyboardType,
      validator: validator,
      textInputAction: textInputAction,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: enabled,
      onChanged: (_) {
        doCheckEnableButtonSave();
      },
    );
  }

  Widget buildWidgetTextFieldPassword() {
    return ValueListenableBuilder(
      valueListenable: valueNotifierShowPassword,
      builder: (BuildContext context, bool isShowPassword, _) {
        return TextFormField(
          controller: controllerPassword,
          decoration: widgetHelper.setDefaultTextFieldDecoration(
            labelText: 'password'.tr(),
            hintText: 'type_to_change'.tr(),
            suffixIcon: InkWell(
              onTap: () {
                valueNotifierShowPassword.value = !valueNotifierShowPassword.value;
              },
              child: Icon(
                isShowPassword ? Icons.visibility : Icons.visibility_off,
              ),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          obscureText: !isShowPassword,
          textInputAction: TextInputAction.go,
          onFieldSubmitted: (_) {
            doSave();
          },
          onChanged: (value) {
            doValidatePassword(value);
            doCheckEnableButtonSave();
          },
        );
      },
    );
  }

  void doSave() {
    final id = userProfile?.id;
    final userRole = userProfile?.role;
    if (id == null) {
      widgetHelper.showSnackBar(context, 'invalid_user_id_2'.tr());
      return;
    } else if (userRole == null) {
      widgetHelper.showSnackBar(context, 'invalid_user_role'.tr());
      return;
    }

    final name = controllerName.text.trim();
    final password = controllerPassword.text.trim();
    userProfileBloc.add(
      UpdateDataUserProfileEvent(
        body: UpdateUserBody(
          name: name,
          userRole: userRole,
          password: password.isEmpty ? null : password,
        ),
        id: id,
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

  Widget buildWidgetButtonSave() {
    final widgetButton = ValueListenableBuilder(
      valueListenable: valueNotifierEnableButtonSave,
      builder: (BuildContext context, bool isEnable, _) {
        return SizedBox(
          width: double.infinity,
          child: WidgetPrimaryButton(
            onPressed: isEnable ? doSave : null,
            isLoading: isLoading,
            child: Text(
              'save'.tr(),
            ),
          ),
        );
      },
    );

    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, state) {
        return widgetButton;
      },
    );
  }
}
