import 'package:dipantau_desktop_client/core/util/enum/sign_up_method.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/core/util/string_extension.dart';
import 'package:dipantau_desktop_client/core/util/widget_helper.dart';
import 'package:dipantau_desktop_client/feature/data/model/kv_setting/kv_setting_body.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/setting/setting_bloc.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_custom_circular_progress_indicator.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_error.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_primary_button.dart';
import 'package:dipantau_desktop_client/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UserRegistrationSettingPage extends StatefulWidget {
  static const routePath = '/user-registration-setting';
  static const routeName = 'user-registration-setting';

  const UserRegistrationSettingPage({Key? key}) : super(key: key);

  @override
  State<UserRegistrationSettingPage> createState() => _UserRegistrationSettingPageState();
}

class _UserRegistrationSettingPageState extends State<UserRegistrationSettingPage> {
  final settingBloc = sl<SettingBloc>();
  final helper = sl<Helper>();
  final widgetHelper = WidgetHelper();

  var isLoadingButton = false;
  var isPreparingSuccess = false;
  SignUpMethod? signUpMethod;

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
    settingBloc.add(LoadKvSettingEvent());
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isLoadingButton,
      child: BlocProvider<SettingBloc>(
        create: (context) => settingBloc,
        child: BlocListener<SettingBloc, SettingState>(
          listener: (context, state) {
            setState(() {
              isLoadingButton = state is LoadingButtonSettingState;
            });
            if (state is FailureSettingState) {
              final errorMessage = state.errorMessage.convertErrorMessageToHumanMessage();
              if (errorMessage.contains('401')) {
                widgetHelper.showDialog401(context);
                return;
              }
            } else if (state is SuccessLoadKvSettingState) {
              isPreparingSuccess = true;
              final strSignUpMethod = state.response?.signUpMethod ?? '';
              signUpMethod = SignUpMethodExtension.parseString(strSignUpMethod);
              signUpMethod ??= SignUpMethod.auto;
            } else if (state is SuccessUpdateKvSettingState) {
              widgetHelper.showSnackBar(
                context,
                'user_registration_workflow_successfully_updated'.tr(),
              );
              context.pop();
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'user_registration_workflow'.tr(),
              ),
              centerTitle: false,
            ),
            body: Padding(
              padding: EdgeInsets.all(helper.getDefaultPaddingLayout),
              child: BlocBuilder<SettingBloc, SettingState>(
                buildWhen: (previousState, currentState) {
                  return currentState is LoadingCenterSettingState ||
                      currentState is FailureSettingState ||
                      currentState is SuccessLoadKvSettingState;
                },
                builder: (context, state) {
                  if (state is FailureSettingState) {
                    final errorMessage = state.errorMessage.convertErrorMessageToHumanMessage();
                    return WidgetError(
                      title: 'oops'.tr(),
                      message: errorMessage.hideResponseCode(),
                      onTryAgain: doLoadData,
                    );
                  } else if (state is LoadingCenterSettingState) {
                    return const WidgetCustomCircularProgressIndicator();
                  }
                  return !isPreparingSuccess ? Container() : buildWidgetForm();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildWidgetForm() {
    return Column(
      children: [
        ListTile(
          leading: Radio(
            value: SignUpMethod.auto,
            groupValue: signUpMethod,
            onChanged: (value) {
              setState(() {
                signUpMethod = value;
              });
            },
          ),
          title: Text('auto_approval'.tr()),
          titleAlignment: ListTileTitleAlignment.top,
          subtitle: Text(
            'description_auto_approval'.tr(),
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          onTap: () {
            setState(() {
              signUpMethod = SignUpMethod.auto;
            });
          },
        ),
        ListTile(
          leading: Radio(
            value: SignUpMethod.manual,
            groupValue: signUpMethod,
            onChanged: (value) {
              setState(() {
                signUpMethod = value;
              });
            },
          ),
          title: Text('manual_approval'.tr()),
          titleAlignment: ListTileTitleAlignment.top,
          subtitle: Text(
            'description_manual_approval'.tr(),
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          onTap: () {
            setState(() {
              signUpMethod = SignUpMethod.manual;
            });
          },
        ),
        Expanded(
          child: Container(),
        ),
        buildWidgetButtonSave(),
      ],
    );
  }

  Widget buildWidgetButtonSave() {
    return SizedBox(
      width: double.infinity,
      child: WidgetPrimaryButton(
        onPressed: saveData,
        isLoading: isLoadingButton,
        child: Text(
          'save'.tr(),
        ),
      ),
    );
  }

  void saveData() {
    String strSignUpMethod;
    if (signUpMethod != null) {
      strSignUpMethod = signUpMethod!.toValue();
    } else {
      widgetHelper.showSnackBar(
        context,
        'please_choose_user_registration_workflow'.tr(),
      );
      return;
    }

    settingBloc.add(
      UpdateKvSettingEvent(
        body: KvSettingBody(
          discordChannelId: null,
          signUpMethod: strSignUpMethod,
        ),
      ),
    );
  }
}
