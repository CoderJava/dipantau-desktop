import 'package:dipantau_desktop_client/core/util/enum/user_role.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/core/util/password_validator.dart';
import 'package:dipantau_desktop_client/core/util/string_extension.dart';
import 'package:dipantau_desktop_client/core/util/widget_helper.dart';
import 'package:dipantau_desktop_client/feature/data/model/sign_up/sign_up_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/update_user/update_user_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_profile/user_profile_response.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/member/member_bloc.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/sign_up/sign_up_bloc.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_primary_button.dart';
import 'package:dipantau_desktop_client/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class AddEditMemberPage extends StatefulWidget {
  static const routePath = '/add-edit-member';
  static const routeName = 'add-edit-member';
  static const parameterDefaultValue = 'default_value';

  final UserProfileResponse? defaultValue;

  const AddEditMemberPage({
    super.key,
    this.defaultValue,
  });

  @override
  State<AddEditMemberPage> createState() => _AddEditMemberPageState();
}

class _AddEditMemberPageState extends State<AddEditMemberPage> {
  final signUpBloc = sl<SignUpBloc>();
  final memberBloc = sl<MemberBloc>();
  final widgetHelper = WidgetHelper();
  final controllerName = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
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
  UserRole? userRole;
  UserProfileResponse? defaultValue;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    defaultValue = widget.defaultValue;
    if (defaultValue != null) {
      controllerName.text = defaultValue?.name ?? '';
      controllerEmail.text = defaultValue?.username ?? '';
      userRole = defaultValue?.role;
      doCheckEnableButtonSave();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            defaultValue != null ? 'edit_member'.tr() : 'add_member'.tr(),
          ),
          centerTitle: false,
        ),
        body: MultiBlocProvider(
          providers: [
            BlocProvider<SignUpBloc>(
              create: (context) => signUpBloc,
            ),
            BlocProvider<MemberBloc>(
              create: (context) => memberBloc,
            ),
          ],
          child: MultiBlocListener(
            listeners: [
              BlocListener<SignUpBloc, SignUpState>(
                listener: (context, state) {
                  setState(() => isLoading = state is LoadingSignUpState);
                  if (state is FailureSignUpState) {
                    final errorMessage = state.errorMessage.convertErrorMessageToHumanMessage();
                    if (errorMessage.contains('401')) {
                      widgetHelper.showDialog401(context);
                      return;
                    }
                    widgetHelper.showSnackBar(context, errorMessage.hideResponseCode());
                  } else if (state is SuccessSubmitSignUpState) {
                    widgetHelper.showSnackBar(
                      context,
                      'create_member_successfully'.tr(),
                    );
                    context.pop(true);
                  }
                },
              ),
              BlocListener<MemberBloc, MemberState>(
                listener: (context, state) {
                  setState(() => isLoading = state is LoadingCenterOverlayMemberState);
                  if (state is FailureMemberState) {
                    final errorMessage = state.errorMessage.convertErrorMessageToHumanMessage();
                    if (errorMessage.contains('401')) {
                      widgetHelper.showDialog401(context);
                      return;
                    }
                    widgetHelper.showSnackBar(context, errorMessage.hideResponseCode());
                  } else if (state is SuccessEditMemberState) {
                    widgetHelper.showSnackBar(
                      context,
                      'update_member_successfully'.tr(),
                    );
                    context.pop(true);
                  }
                },
              ),
            ],
            child: Form(
              key: formState,
              child: ListView(
                padding: EdgeInsets.only(
                  left: helper.getDefaultPaddingLayout,
                  top: helper.getDefaultPaddingLayout,
                  right: helper.getDefaultPaddingLayout,
                  bottom: helper.getDefaultPaddingLayoutBottom,
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
                    enabled: defaultValue == null,
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
                  buildWidgetFieldRole(),
                  defaultValue != null ? Container() : const SizedBox(height: 24),
                  buildWidgetTextFieldPassword(),
                  defaultValue != null ? Container() : const SizedBox(height: 12),
                  buildWidgetPasswordValidator(),
                  const SizedBox(height: 24),
                  buildWidgetButtonSave(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildWidgetTextFieldPassword() {
    if (defaultValue != null) {
      return Container();
    }

    return ValueListenableBuilder(
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
              child: Icon(
                isShowPassword ? Icons.visibility : Icons.visibility_off,
              ),
            ),
          ),
          obscureText: !isShowPassword,
          textInputAction: TextInputAction.go,
          onFieldSubmitted: (_) {
            doSave();
          },
          validator: (value) {
            return value == null || value.isEmpty ? 'password_is_required'.tr() : null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (value) {
            doValidatePassword(value);
            doCheckEnableButtonSave();
          },
        );
      },
    );
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

  void doSave() {
    final name = controllerName.text.trim();
    final email = controllerEmail.text.trim();
    final password = controllerPassword.text.trim();

    if (defaultValue == null) {
      signUpBloc.add(
        SubmitSignUpEvent(
          body: SignUpBody(
            name: name,
            email: email,
            password: password,
            userRole: userRole!,
          ),
        ),
      );
    } else {
      final id = defaultValue?.id;
      if (id == null) {
        widgetHelper.showSnackBar(context, 'invalid_user_id_2'.tr());
        return;
      } else if (userRole == null) {
        widgetHelper.showSnackBar(context, 'invalid_user_role'.tr());
      }

      memberBloc.add(
        EditMemberEvent(
          body: UpdateUserBody(
            name: name,
            userRole: userRole!,
            password: null,
          ),
          id: id,
        ),
      );
    }
  }

  void doCheckEnableButtonSave() {
    var isEnableTemp = false;
    final name = controllerName.text.trim();
    final email = controllerEmail.text.trim();
    final password = controllerPassword.text.trim();
    final passwordLengthValid = valueNotifierPasswordLength.value;
    final passwordLowerCaseValid = valueNotifierPasswordLowerCase.value;
    final passwordUpperCaseValid = valueNotifierPasswordUpperCase.value;
    final passwordNumericCharValid = valueNotifierPasswordNumericChar.value;
    final passwordSpecialCharValid = valueNotifierPasswordSpecialChar.value;
    if (defaultValue == null) {
      if (name.isNotEmpty &&
          email.isNotEmpty &&
          userRole != null &&
          password.isNotEmpty &&
          passwordLengthValid &&
          passwordLowerCaseValid &&
          passwordUpperCaseValid &&
          passwordNumericCharValid &&
          passwordSpecialCharValid) {
        isEnableTemp = true;
      }
    } else {
      if (name.isNotEmpty && email.isNotEmpty && userRole != null) {
        isEnableTemp = true;
      }
    }

    if (isEnableTemp != valueNotifierEnableButtonSave.value) {
      valueNotifierEnableButtonSave.value = isEnableTemp;
    }
  }

  Widget buildWidgetFieldRole() {
    final items = <_ItemUserRole>[
      _ItemUserRole(
        userRole: UserRole.superAdmin,
        title: 'super_admin'.tr(),
        subtitle: 'subtitle_super_admin'.tr(),
      ),
      _ItemUserRole(
        userRole: UserRole.admin,
        title: 'admin'.tr(),
        subtitle: 'subtitle_admin'.tr(),
      ),
      _ItemUserRole(
        userRole: UserRole.employee,
        title: 'employee'.tr(),
        subtitle: 'subtitle_employee'.tr(),
      ),
    ];
    return DropdownButtonFormField(
      value: userRole,
      decoration: widgetHelper.setDefaultTextFieldDecoration(
        labelText: 'role'.tr(),
        hintText: 'select_role'.tr(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      items: items.map((element) {
        return DropdownMenuItem(
          value: element.userRole,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                element.title,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                element.subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        userRole = value;
        doCheckEnableButtonSave();
        setState(() {});
      },
      selectedItemBuilder: (context) {
        return items.map((element) {
          final strUserRole = element.userRole.toName.tr();
          return Text(strUserRole);
        }).toList();
      },
      validator: (value) {
        return value == null ? 'role_is_required'.tr() : null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      padding: EdgeInsets.zero,
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

    if (defaultValue == null) {
      return BlocBuilder<SignUpBloc, SignUpState>(
        builder: (context, state) {
          return widgetButton;
        },
      );
    } else {
      return BlocBuilder<MemberBloc, MemberState>(
        builder: (context, state) {
          return widgetButton;
        },
      );
    }
  }

  Widget buildWidgetPasswordValidator() {
    if (defaultValue != null) {
      return Container();
    }

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
}

class _ItemUserRole {
  final UserRole userRole;
  final String title;
  final String subtitle;

  _ItemUserRole({
    required this.userRole,
    required this.title,
    required this.subtitle,
  });
}
