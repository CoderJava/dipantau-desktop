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

class SettingDiscordPage extends StatefulWidget {
  static const routePath = '/setting-discord';
  static const routeName = 'setting-discord';

  const SettingDiscordPage({Key? key}) : super(key: key);

  @override
  State<SettingDiscordPage> createState() => _SettingDiscordPageState();
}

class _SettingDiscordPageState extends State<SettingDiscordPage> {
  final settingBloc = sl<SettingBloc>();
  final widgetHelper = WidgetHelper();
  final controllerDiscordChannelId = TextEditingController();
  final helper = sl<Helper>();
  final formState = GlobalKey<FormState>();

  var isLoadingButton = false;
  var discordChannelId = '';
  var isPreparingSuccess = false;

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
            setState(() => isLoadingButton = state is LoadingButtonSettingState);
            if (state is FailureSettingState) {
              final errorMessage = state.errorMessage.convertErrorMessageToHumanMessage();
              if (errorMessage.contains('401')) {
                widgetHelper.showDialog401(context);
                return;
              }
            } else if (state is SuccessLoadKvSettingState) {
              isPreparingSuccess = true;
              discordChannelId = state.response?.discordChannelId ?? '';
              controllerDiscordChannelId.text = discordChannelId;
            } else if (state is FailureSnackBarSettingState) {
              final errorMessage = state.errorMessage.convertErrorMessageToHumanMessage();
              widgetHelper.showSnackBar(context, errorMessage.hideResponseCode());
            } else if (state is SuccessUpdateKvSettingState) {
              widgetHelper.showSnackBar(context, 'discord_channel_id_sucessfully_updated'.tr());
              context.pop();
            }
          },
          child: Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: EdgeInsets.only(
                left: helper.getDefaultPaddingLayout,
                top: helper.getDefaultPaddingLayoutTop,
                right: helper.getDefaultPaddingLayout,
                bottom: helper.getDefaultPaddingLayout,
              ),
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
    return SizedBox(
      width: double.infinity,
      child: Form(
        key: formState,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildWidgetTitle(),
            const SizedBox(height: 8),
            Text(
              'subtitle_discord_channel_id'.tr(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 24),
            buildWidgetTextFieldDiscordChannelId(),
            const SizedBox(height: 24),
            buildWidgetButtonSave(),
          ],
        ),
      ),
    );
  }

  Widget buildWidgetTitle() {
    return Text(
      'set_discord_channel_id'.tr(),
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  Widget buildWidgetTextFieldDiscordChannelId() {
    return TextFormField(
      autofocus: true,
      controller: controllerDiscordChannelId,
      decoration: widgetHelper.setDefaultTextFieldDecoration(
        labelText: 'discord_channel_id_2'.tr(),
        hintText: 'example_discord_channel_id'.tr(),
      ),
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.go,
      onFieldSubmitted: (_) {
        saveData();
      },
      enabled: !isLoadingButton,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'cannot_be_empty'.tr();
        }
        return null;
      },
    );
  }

  void saveData() {
    if (formState.currentState!.validate()) {
      final discordChannelId = controllerDiscordChannelId.text.trim();
      settingBloc.add(
        UpdateKvSettingEvent(
          body: KvSettingBody(
            discordChannelId: discordChannelId,
          ),
        ),
      );
    }
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
}
