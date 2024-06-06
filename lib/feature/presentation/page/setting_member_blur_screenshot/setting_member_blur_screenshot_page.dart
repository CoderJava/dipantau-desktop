import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/core/util/string_extension.dart';
import 'package:dipantau_desktop_client/core/util/widget_helper.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_setting/user_setting_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_setting/user_setting_response.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/setting/setting_bloc.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_custom_circular_progress_indicator.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_error.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_primary_button.dart';
import 'package:dipantau_desktop_client/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingMemberBlurScreenshotPage extends StatefulWidget {
  static const routePath = '/member-blur-screenshot';
  static const routeName = 'member-blur-screenshot';

  const SettingMemberBlurScreenshotPage({super.key});

  @override
  State<SettingMemberBlurScreenshotPage> createState() => _SettingMemberBlurScreenshotPageState();
}

class _SettingMemberBlurScreenshotPageState extends State<SettingMemberBlurScreenshotPage> {
  final settingBloc = sl<SettingBloc>();
  final widgetHelper = WidgetHelper();
  final helper = sl<Helper>();
  final listData = <_ItemSettingMember>[];

  var isLoadingButton = false;
  var isOverride = false;

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
    settingBloc.add(LoadAllUserSettingEvent());
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
            } else if (state is FailureSnackBarSettingState) {
              final errorMessage = state.errorMessage.convertErrorMessageToHumanMessage();
              if (errorMessage.contains('401')) {
                widgetHelper.showDialog401(context);
                return;
              }
              widgetHelper.showSnackBar(context, errorMessage.hideResponseCode());
            } else if (state is SuccessLoadAllUserSettingState) {
              isOverride = state.response.isOverrideBlurScreenshot ?? false;
              listData.clear();
              for (final element in state.response.data ?? <UserSettingResponse>[]) {
                final id = element.id ?? -1;
                final userId = element.userId ?? -1;
                final name = element.name ?? '';
                if (id == -1 || userId == -1 || name.isEmpty) {
                  continue;
                }
                listData.add(
                  _ItemSettingMember(
                    id: id,
                    userId: userId,
                    name: name,
                    isEnableBlurScreenshot: element.isEnableBlurScreenshot ?? false,
                  ),
                );
              }
            } else if (state is SuccessUpdateUserSettingState) {
              widgetHelper.showSnackBar(context, 'user_setting_updated_successfully'.tr());
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'screenshot_blur'.tr(),
              ),
              centerTitle: false,
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: helper.getDefaultPaddingLayout),
              child: BlocBuilder<SettingBloc, SettingState>(
                builder: (context, state) {
                  if (state is LoadingCenterSettingState) {
                    return const WidgetCustomCircularProgressIndicator();
                  } else if (state is FailureSettingState) {
                    final errorMessage = state.errorMessage.convertErrorMessageToHumanMessage();
                    return WidgetError(
                      title: 'oops'.tr(),
                      message: errorMessage.hideResponseCode(),
                      onTryAgain: doLoadData,
                    );
                  }
                  if (listData.isEmpty) {
                    return WidgetError(
                      title: 'info'.tr(),
                      message: 'no_data_to_display'.tr(),
                    );
                  }

                  return Column(
                    children: [
                      SizedBox(height: helper.getDefaultPaddingLayoutTop),
                      buildWidgetOverrideSetting(),
                      isOverride
                          ? Expanded(
                              child: Column(
                                children: [
                                  const SizedBox(height: 16),
                                  const Divider(),
                                  const SizedBox(height: 8),
                                  buildWidgetActionAll(),
                                  const SizedBox(height: 4),
                                  Expanded(
                                    child: buildWidgetListData(),
                                  ),
                                ],
                              ),
                            )
                          : Expanded(
                              child: Container(),
                            ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 16,
                          bottom: helper.getDefaultPaddingLayoutBottom,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: WidgetPrimaryButton(
                            onPressed: submit,
                            isLoading: isLoadingButton,
                            child: Text(
                              'save'.tr(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildWidgetActionAll() {
    return Row(
      children: [
        Text(
          'member_n'.plural(listData.length),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
        ),
        Expanded(
          child: Container(),
        ),
        TextButton(
          onPressed: () {
            for (final itemData in listData) {
              itemData.isEnableBlurScreenshot = false;
            }
            setState(() {});
          },
          child: Text('disable_all'.tr()),
        ),
        Container(
          width: 1,
          height: 24,
          color: Colors.grey,
          margin: const EdgeInsets.symmetric(horizontal: 8),
        ),
        TextButton(
          onPressed: () {
            for (final itemData in listData) {
              itemData.isEnableBlurScreenshot = true;
            }
            setState(() {});
          },
          child: Text('enable_all'.tr()),
        ),
      ],
    );
  }

  void submit() {
    UserSettingBody body;
    if (isOverride) {
      body = UserSettingBody(
        data: listData
            .map(
              (e) => ItemUserSettingBody(
                id: e.id,
                isEnableBlurScreenshot: e.isEnableBlurScreenshot,
                userId: e.userId,
              ),
            )
            .toList(),
        isOverrideBlurScreenshot: isOverride,
      );
    } else {
      body = UserSettingBody(
        data: [],
        isOverrideBlurScreenshot: false,
      );
    }
    settingBloc.add(
      UpdateUserSettingEvent(
        body: body,
      ),
    );
  }

  Widget buildWidgetListData() {
    return ListView.separated(
      padding: EdgeInsets.only(
        top: helper.getDefaultPaddingLayoutTop,
      ),
      itemBuilder: (context, index) {
        final element = listData[index];
        final isEnableBlurScreenshot = element.isEnableBlurScreenshot;
        return Row(
          children: [
            Expanded(
              child: Text(element.name),
            ),
            Switch.adaptive(
              value: isEnableBlurScreenshot,
              activeColor: Theme.of(context).colorScheme.primary,
              onChanged: (newValue) {
                listData[index].isEnableBlurScreenshot = newValue;
                setState(() {});
              },
            ),
          ],
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: listData.length,
    );
  }

  Widget buildWidgetOverrideSetting() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'override'.tr(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                'description_override_member_blur_screenshot'.tr(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Switch.adaptive(
          value: isOverride,
          activeColor: Theme.of(context).colorScheme.primary,
          onChanged: (value) {
            setState(() => isOverride = value);
          },
        ),
      ],
    );
  }
}

class _ItemSettingMember {
  final int id;
  final int userId;
  final String name;
  bool isEnableBlurScreenshot;

  _ItemSettingMember({
    required this.id,
    required this.userId,
    required this.name,
    required this.isEnableBlurScreenshot,
  });

  @override
  String toString() {
    return '_ItemSettingMember{id: $id, userId: $userId, name: $name, isEnableBlurScreenshot: $isEnableBlurScreenshot}';
  }
}
