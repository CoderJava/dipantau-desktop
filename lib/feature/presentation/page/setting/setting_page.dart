import 'package:auto_updater/auto_updater.dart';
import 'package:dipantau_desktop_client/core/util/enum/appearance_mode.dart';
import 'package:dipantau_desktop_client/core/util/enum/global_variable.dart';
import 'package:dipantau_desktop_client/core/util/enum/user_role.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/core/util/string_extension.dart';
import 'package:dipantau_desktop_client/core/util/widget_helper.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_setting/user_setting_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_setting/user_setting_response.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/appearance/appearance_bloc.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/setting/setting_bloc.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/home/home_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/member_setting/member_setting_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/setting_discord/setting_discord_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/setting_member_blur_screenshot/setting_member_blur_screenshot_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/setup_credential/setup_credential_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/splash/splash_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_custom_circular_progress_indicator.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_primary_button.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_theme_container.dart';
import 'package:dipantau_desktop_client/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:window_manager/window_manager.dart';

class SettingPage extends StatefulWidget {
  static const routePath = '/setting';
  static const routeName = 'setting';

  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final settingBloc = sl<SettingBloc>();
  final helper = sl<Helper>();
  final navigationRailDestinations = <NavigationRailDestination>[];
  final sharedPreferencesManager = sl<SharedPreferencesManager>();
  final valueNotifierIsEnableScreenshotNotification = ValueNotifier(false);
  final valueNotifierIsEnableSoundScreenshotNotification = ValueNotifier(true);
  final valueNotifierAppearanceMode = ValueNotifier(AppearanceMode.light);
  final valueNotifierLaunchAtStartup = ValueNotifier(true);
  final valueNotifierAlwaysOnTop = ValueNotifier(true);
  final valueNotifierIsEnableReminderTrack = ValueNotifier(false);
  final widgetHelper = WidgetHelper();
  final controllerStartTimeReminderTrackNotification = TextEditingController();
  final controllerFinishTimeReminderTrackNotification = TextEditingController();
  final controllerIntervalReminderTrackNotification = TextEditingController();

  var selectedIndexNavigationRail = 0;
  UserRole? userRole;
  var hostname = '';
  late AppearanceBloc appearanceBloc;
  var isEnableReminderTrackMon = true;
  var isEnableReminderTrackTue = true;
  var isEnableReminderTrackWed = true;
  var isEnableReminderTrackThu = true;
  var isEnableReminderTrackFri = true;
  var isEnableReminderTrackSat = false;
  var isEnableReminderTrackSun = false;
  UserSettingResponse? userSetting;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    launchAtStartup.isEnabled().then((value) {
      valueNotifierLaunchAtStartup.value = value;
    });
    appearanceBloc = BlocProvider.of<AppearanceBloc>(context);
    final strUserRole = sharedPreferencesManager.getString(SharedPreferencesManager.keyUserRole) ?? '';
    userRole = strUserRole.fromStringUserRole;
    prepareData();
    doLoadUserSetting();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setupNavigationRailDestinations();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingBloc>(
      create: (context) => settingBloc,
      child: BlocListener<SettingBloc, SettingState>(
        listener: (context, state) {
          if (state is SuccessLoadUserSettingState) {
            userSetting = state.response;
          } else if (state is SuccessUpdateUserSettingState) {
            final newUserSetting = UserSettingResponse(
              id: userSetting!.id!,
              isEnableBlurScreenshot: !(userSetting!.isEnableBlurScreenshot!),
              userId: userSetting!.userId,
              name: userSetting!.name,
            );
            userSetting = newUserSetting;
          } else if (state is FailureSettingState) {
            final errorMessage = state.errorMessage.convertErrorMessageToHumanMessage();
            if (errorMessage.contains('401')) {
              widgetHelper.showDialog401(context);
              return;
            }
            widgetHelper.showSnackBar(context, errorMessage.hideResponseCode());
          } else if (state is FailureSnackBarSettingState) {
            final errorMessage = state.errorMessage.convertErrorMessageToHumanMessage();
            if (errorMessage.contains('401')) {
              widgetHelper.showDialog401(context);
              return;
            }
            widgetHelper.showSnackBar(context, errorMessage.hideResponseCode());
          }
        },
        child: Scaffold(
          body: navigationRailDestinations.isEmpty
              ? Container()
              : Row(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: 172,
                            child: NavigationRail(
                              destinations: navigationRailDestinations,
                              selectedIndex: selectedIndexNavigationRail,
                              onDestinationSelected: (newValue) {
                                if (newValue == 0) {
                                  doLoadUserSetting();
                                }
                                setState(() => selectedIndexNavigationRail = newValue);
                              },
                              extended: true,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: TextButton(
                            onPressed: () => context.pop(),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'back_to_main_menu'.tr(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const VerticalDivider(
                      thickness: 1,
                      width: 1,
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: buildWidgetBody(),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void setupNavigationRailDestinations() {
    navigationRailDestinations.addAll(
      [
        NavigationRailDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings),
          label: Text('general'.tr()),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.notifications_outlined),
          selectedIcon: const Icon(Icons.notifications),
          label: Text('notification'.tr()),
        ),
      ],
    );
    if (userRole == UserRole.superAdmin) {
      navigationRailDestinations.add(
        NavigationRailDestination(
          icon: const Icon(Icons.business_center_outlined),
          selectedIcon: const Icon(Icons.business_center),
          label: Text('company'.tr()),
        ),
      );
    }
  }

  Widget buildWidgetBody() {
    if (selectedIndexNavigationRail == 0) {
      return buildWidgetBodyGeneral();
    } else if (selectedIndexNavigationRail == 1) {
      return buildWidgetBodyNotification();
    } else if (selectedIndexNavigationRail == 2) {
      return buildWidgetBodyCompany();
    }
    return Container();
  }

  Widget buildWidgetBodyGeneral() {
    return ListView(
      padding: EdgeInsets.only(
        left: helper.getDefaultPaddingLayout,
        top: helper.getDefaultPaddingLayoutTop,
        right: helper.getDefaultPaddingLayout,
        bottom: helper.getDefaultPaddingLayout,
      ),
      children: [
        buildWidgetLaunchAtStartup(),
        const SizedBox(height: 16),
        buildWidgetSetHostName(),
        const SizedBox(height: 16),
        buildWidgetAlwaysOnTop(),
        const SizedBox(height: 16),
        buildWidgetUserSetting(),
        const SizedBox(height: 16),
        buildWidgetChooseAppearance(),
        const SizedBox(height: 16),
        buildWidgetCheckForUpdate(),
        const SizedBox(height: 24),
        buildWidgetButtonLogout(),
      ],
    );
  }

  Widget buildWidgetLaunchAtStartup() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'launch_at_startup'.tr(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                'subtitle_launch_at_startup'.tr(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        ValueListenableBuilder(
          valueListenable: valueNotifierLaunchAtStartup,
          builder: (BuildContext context, bool value, _) {
            return Switch.adaptive(
              value: value,
              onChanged: (newValue) async {
                if (newValue) {
                  await launchAtStartup.enable();
                } else {
                  await launchAtStartup.disable();
                }
                sharedPreferencesManager.putBool(
                  SharedPreferencesManager.keyIsLaunchAtStartup,
                  newValue,
                );
                valueNotifierLaunchAtStartup.value = newValue;
              },
              activeColor: Theme.of(context).colorScheme.primary,
            );
          },
        ),
      ],
    );
  }

  Widget buildWidgetBodyNotification() {
    return ListView(
      padding: EdgeInsets.only(
        left: helper.getDefaultPaddingLayout,
        top: helper.getDefaultPaddingLayoutTop,
        right: helper.getDefaultPaddingLayout,
        bottom: helper.getDefaultPaddingLayout,
      ),
      children: [
        buildWidgetScreenshotNotification(),
        buildWidgetPlaySoundScreenshotNotification(),
        const SizedBox(height: 16),
        buildWidgetReminderNotTrackNotification(),
        const SizedBox(height: 8),
        buildWidgetSetupReminderNotTrackNotification(),
      ],
    );
  }

  Widget buildWidgetSetupReminderNotTrackNotification() {
    final isEnabled = valueNotifierIsEnableReminderTrack.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'from'.tr(),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 64,
              height: 24,
              child: TextField(
                controller: controllerStartTimeReminderTrackNotification,
                decoration: widgetHelper.setDefaultTextFieldDecoration().copyWith(
                      isDense: true,
                      counterText: '',
                      contentPadding: const EdgeInsets.only(
                        top: 8,
                      ),
                    ),
                enabled: isEnabled,
                textAlign: TextAlign.center,
                maxLines: 1,
                maxLength: 5,
                readOnly: true,
                onTap: !isEnabled
                    ? null
                    : () async {
                        final strStart = controllerStartTimeReminderTrackNotification.text.trim();
                        var initialTime = TimeOfDay.now();
                        if (strStart.contains(':')) {
                          final strStartHour = strStart.split(':').first;
                          final strStartMinute = strStart.split(':').last;
                          final startHour = int.tryParse(strStartHour);
                          final startMinute = int.tryParse(strStartMinute);
                          if (startHour != null && startMinute != null) {
                            initialTime = TimeOfDay(hour: startHour, minute: startMinute);
                          }
                        }
                        final result = await showTimePicker(
                          context: context,
                          initialTime: initialTime,
                          initialEntryMode: TimePickerEntryMode.input,
                        );
                        if (result != null) {
                          final hour = result.hour;
                          final minute = result.minute;
                          var strResult = hour < 10 ? '0$hour' : hour.toString();
                          strResult += ':';
                          strResult += minute < 10 ? '0$minute' : minute.toString();
                          controllerStartTimeReminderTrackNotification.text = strResult;
                          updateReminderTrack();
                          setState(() {});
                        }
                      },
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'to'.tr(),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 64,
              height: 24,
              child: TextField(
                controller: controllerFinishTimeReminderTrackNotification,
                decoration: widgetHelper.setDefaultTextFieldDecoration().copyWith(
                      isDense: true,
                      counterText: '',
                      contentPadding: const EdgeInsets.only(
                        top: 8,
                      ),
                    ),
                enabled: isEnabled,
                textAlign: TextAlign.center,
                maxLines: 1,
                maxLength: 5,
                readOnly: true,
                onTap: !isEnabled
                    ? null
                    : () async {
                        final strFinish = controllerFinishTimeReminderTrackNotification.text.trim();
                        var initialTime = TimeOfDay.now();
                        if (strFinish.contains(':')) {
                          final strFinishHour = strFinish.split(':').first;
                          final strFinishMinute = strFinish.split(':').last;
                          final finishHour = int.tryParse(strFinishHour);
                          final finishMinute = int.tryParse(strFinishMinute);
                          if (finishHour != null && finishMinute != null) {
                            initialTime = TimeOfDay(hour: finishHour, minute: finishMinute);
                          }
                        }
                        final result = await showTimePicker(
                          context: context,
                          initialTime: initialTime,
                          initialEntryMode: TimePickerEntryMode.input,
                        );
                        if (result != null) {
                          final finishHour = result.hour;
                          final finishMinute = result.minute;
                          final now = DateTime.now();
                          final strStart = controllerStartTimeReminderTrackNotification.text.trim();
                          if (strStart.contains(':')) {
                            final strStartHour = strStart.split(':').first;
                            final strStartMinute = strStart.split(':').last;
                            final startHour = int.tryParse(strStartHour);
                            final startMinute = int.tryParse(strStartMinute);
                            if (startHour != null && startMinute != null) {
                              final startReminderDateTime = DateTime(
                                now.year,
                                now.month,
                                now.day,
                                startHour,
                                startMinute,
                              );
                              final finishReminderDateTime = DateTime(
                                now.year,
                                now.month,
                                now.day,
                                finishHour,
                                finishMinute,
                              );
                              if ((finishReminderDateTime.isBefore(startReminderDateTime) ||
                                      finishReminderDateTime.isAtSameMomentAs(startReminderDateTime)) &&
                                  mounted) {
                                widgetHelper.showSnackBar(context, 'finish_time_must_be_after_start_time'.tr());
                                return;
                              }
                            }
                          }

                          var strResult = finishHour < 10 ? '0$finishHour' : finishHour.toString();
                          strResult += ':';
                          strResult += finishMinute < 10 ? '0$finishMinute' : finishMinute.toString();
                          controllerFinishTimeReminderTrackNotification.text = strResult;
                          updateReminderTrack();
                          setState(() {});
                        }
                      },
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'on_these_days'.tr(),
        ),
        Wrap(
          spacing: 8,
          children: [
            buildWidgetItemDay(
              'mon'.tr(),
              isEnableReminderTrackMon,
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() => isEnableReminderTrackMon = newValue);
                }
              },
            ),
            buildWidgetItemDay(
              'tue'.tr(),
              isEnableReminderTrackTue,
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() => isEnableReminderTrackTue = newValue);
                }
              },
            ),
            buildWidgetItemDay(
              'wed'.tr(),
              isEnableReminderTrackWed,
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() => isEnableReminderTrackWed = newValue);
                }
              },
            ),
            buildWidgetItemDay(
              'thu'.tr(),
              isEnableReminderTrackThu,
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() => isEnableReminderTrackThu = newValue);
                }
              },
            ),
            buildWidgetItemDay(
              'fri'.tr(),
              isEnableReminderTrackFri,
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() => isEnableReminderTrackFri = newValue);
                }
              },
            ),
            buildWidgetItemDay(
              'sat'.tr(),
              isEnableReminderTrackSat,
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() => isEnableReminderTrackSat = newValue);
                }
              },
            ),
            buildWidgetItemDay(
              'sun'.tr(),
              isEnableReminderTrackSun,
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() => isEnableReminderTrackSun = newValue);
                }
              },
            ),
          ],
        ),
        Row(
          children: [
            Text(
              'if_i_havent_tracked_time_in'.tr(),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 36,
              height: 24,
              child: TextField(
                controller: controllerIntervalReminderTrackNotification,
                decoration: widgetHelper.setDefaultTextFieldDecoration().copyWith(
                      isDense: true,
                      counterText: '',
                      contentPadding: const EdgeInsets.only(
                        top: 8,
                      ),
                    ),
                enabled: isEnabled,
                textAlign: TextAlign.center,
                maxLines: 1,
                maxLength: 2,
                keyboardType: TextInputType.number,
                readOnly: true,
                onTap: !isEnabled
                    ? null
                    : () async {
                        final elements = <int>[];
                        var counter = 0;
                        for (var number = 1; number <= 12; number++) {
                          counter += 5;
                          elements.add(counter);
                        }
                        final result = await showCupertinoModalPopup<int?>(
                          context: context,
                          builder: (context) {
                            final strInterval = controllerIntervalReminderTrackNotification.text.trim();
                            var indexSelected = elements.indexWhere((element) => element.toString() == strInterval);
                            if (indexSelected == -1) {
                              indexSelected = 0;
                            }
                            return Container(
                              height: 192,
                              padding: const EdgeInsets.all(16),
                              color: CupertinoColors.systemBackground.resolveFrom(context),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: CupertinoPicker(
                                      squeeze: 1,
                                      itemExtent: 28,
                                      useMagnifier: true,
                                      scrollController: FixedExtentScrollController(
                                        initialItem: indexSelected,
                                      ),
                                      onSelectedItemChanged: (int value) {
                                        indexSelected = value;
                                      },
                                      children: elements.map(
                                        (e) {
                                          return Text(
                                            'n_minute'.tr(
                                              args: [
                                                e.toString(),
                                              ],
                                            ),
                                          );
                                        },
                                      ).toList(),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: WidgetPrimaryButton(
                                      onPressed: () => context.pop(elements[indexSelected]),
                                      child: Text('choose'.tr()),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                        if (result != null) {
                          controllerIntervalReminderTrackNotification.text = result.toString();
                          updateReminderTrack();
                          setState(() {});
                        }
                      },
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'alias_minutes'.tr(),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildWidgetItemDay(String label, bool value, {ValueChanged<bool?>? onChanged}) {
    final isEnabled = valueNotifierIsEnableReminderTrack.value;
    return SizedBox(
      width: 60,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24,
            child: Checkbox(
              value: value,
              onChanged: !isEnabled
                  ? null
                  : (newValue) {
                      onChanged?.call(newValue);
                      updateReminderTrack();
                    },
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }

  Widget buildWidgetReminderNotTrackNotification() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'remind_me_to_track_time'.tr(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                'subtitle_remind_me_to_track_time'.tr(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        ValueListenableBuilder(
          valueListenable: valueNotifierIsEnableReminderTrack,
          builder: (BuildContext context, bool value, _) {
            return Switch.adaptive(
              value: value,
              onChanged: (newValue) {
                sharedPreferencesManager.putBool(
                  SharedPreferencesManager.keyIsEnableReminderTrack,
                  newValue,
                );
                valueNotifierIsEnableReminderTrack.value = newValue;
                updateReminderTrack();
                setState(() {});
              },
              activeColor: Theme.of(context).colorScheme.primary,
            );
          },
        ),
      ],
    );
  }

  Widget buildWidgetBodyCompany() {
    return ListView(
      padding: EdgeInsets.only(
        left: helper.getDefaultPaddingLayout,
        top: helper.getDefaultPaddingLayoutTop,
        right: helper.getDefaultPaddingLayout,
        bottom: helper.getDefaultPaddingLayout,
      ),
      children: [
        buildWidgetMember(),
        const SizedBox(height: 16),
        buildWidgetProject(),
        const SizedBox(height: 16),
        buildWidgetTask(),
        const SizedBox(height: 16),
        buildWidgetDiscordChannelId(),
        const SizedBox(height: 16),
        buildWidgetMemberBlurScreenshot(),
      ],
    );
  }

  void prepareData() {
    valueNotifierIsEnableScreenshotNotification.value =
        sharedPreferencesManager.getBool(SharedPreferencesManager.keyIsEnableScreenshotNotification) ?? false;
    valueNotifierIsEnableSoundScreenshotNotification.value =
        sharedPreferencesManager.getBool(SharedPreferencesManager.keyIsEnableSoundScreenshotNotification) ?? false;
    valueNotifierAlwaysOnTop.value =
        sharedPreferencesManager.getBool(SharedPreferencesManager.keyIsAlwaysOnTop, defaultValue: true) ?? true;

    hostname = sharedPreferencesManager.getString(
          SharedPreferencesManager.keyDomainApi,
        ) ??
        '';
    if (hostname.isEmpty) {
      hostname = '-';
    }

    final strAppearanceMode =
        sharedPreferencesManager.getString(SharedPreferencesManager.keyAppearanceMode) ?? AppearanceMode.light.name;
    final appearanceMode = strAppearanceMode.fromStringAppearanceMode;
    if (appearanceMode != null) {
      valueNotifierAppearanceMode.value = appearanceMode;
    }

    valueNotifierIsEnableReminderTrack.value =
        sharedPreferencesManager.getBool(SharedPreferencesManager.keyIsEnableReminderTrack) ?? false;
    controllerStartTimeReminderTrackNotification.text =
        sharedPreferencesManager.getString(SharedPreferencesManager.keyStartTimeReminderTrack, defaultValue: '08:30') ??
            '08:30';
    controllerFinishTimeReminderTrackNotification.text = sharedPreferencesManager
            .getString(SharedPreferencesManager.keyFinishTimeReminderTrack, defaultValue: '17:00') ??
        '17:00';
    controllerIntervalReminderTrackNotification.text = (sharedPreferencesManager.getInt(
              SharedPreferencesManager.keyIntervalReminderTrack,
            ) ??
            15)
        .toString();
  }

  Widget buildWidgetSetHostName() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'hostname'.tr(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                hostname,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () {
            context.pushNamed(
              SetupCredentialPage.routeName,
              extra: {
                SetupCredentialPage.parameterIsShowWarning: true,
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildWidgetCheckForUpdate() {
    final versionName = packageInfo.version;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'version_app'.tr(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                versionName,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        WidgetPrimaryButton(
          onPressed: () {
            const feedURL = autoUpdaterUrl;
            autoUpdater.setFeedURL(feedURL);
            autoUpdater.checkForUpdates();
          },
          child: Text(
            'check'.tr(),
          ),
        ),
      ],
    );
  }

  Widget buildWidgetChooseAppearance() {
    const height = 64.0;
    final primaryColor = Theme.of(context).colorScheme.primary;
    return ValueListenableBuilder(
      valueListenable: valueNotifierAppearanceMode,
      builder: (BuildContext context, AppearanceMode appearance, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'appearance'.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          updateAppearanceMode(AppearanceMode.light);
                        },
                        child: WidgetThemeContainer(
                          mode: AppearanceMode.light,
                          width: double.infinity,
                          height: height,
                          borderColor: appearance == AppearanceMode.light ? primaryColor : null,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'light'.tr(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: appearance == AppearanceMode.light ? primaryColor : null,
                              fontWeight: appearance == AppearanceMode.light ? FontWeight.bold : FontWeight.normal,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          updateAppearanceMode(AppearanceMode.dark);
                        },
                        child: WidgetThemeContainer(
                          mode: AppearanceMode.dark,
                          width: double.infinity,
                          height: height,
                          borderColor: appearance == AppearanceMode.dark ? primaryColor : null,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'dark'.tr(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: appearance == AppearanceMode.dark ? primaryColor : null,
                              fontWeight: appearance == AppearanceMode.dark ? FontWeight.bold : FontWeight.normal,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          updateAppearanceMode(AppearanceMode.system);
                        },
                        child: WidgetThemeContainer(
                          mode: AppearanceMode.system,
                          width: double.infinity,
                          height: height,
                          borderColor: appearance == AppearanceMode.system ? primaryColor : null,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'system'.tr(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: appearance == AppearanceMode.system ? primaryColor : null,
                              fontWeight: appearance == AppearanceMode.system ? FontWeight.bold : FontWeight.normal,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void updateAppearanceMode(AppearanceMode appearance) {
    valueNotifierAppearanceMode.value = appearance;
    sharedPreferencesManager.putString(SharedPreferencesManager.keyAppearanceMode, appearance.name);
    switch (appearance) {
      case AppearanceMode.light:
        appearanceBloc.add(UpdateAppearanceEvent(isDarkMode: false));
        break;
      case AppearanceMode.dark:
        appearanceBloc.add(UpdateAppearanceEvent(isDarkMode: true));
        break;
      case AppearanceMode.system:
        final brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
        appearanceBloc.add(UpdateAppearanceEvent(isDarkMode: brightness == Brightness.dark));
        break;
    }
  }

  Widget buildWidgetButtonLogout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WidgetPrimaryButton(
          onPressed: doLogout,
          buttonStyle: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[300],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32),
          ),
          child: Text('logout'.tr()),
        ),
      ],
    );
  }

  Future<void> doLogout() async {
    final isLogout = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'confirm_logout'.tr(),
          ),
          content: Text(
            'description_logout'.tr(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('cancel'.tr()),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text('yes'.tr()),
            ),
          ],
        );
      },
    ) as bool?;
    if (isLogout != null && mounted) {
      await helper.setLogout();
      if (mounted) {
        context.goNamed(SplashPage.routeName);
      }
    }
  }

  Widget buildWidgetAlwaysOnTop() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'always_on_top'.tr(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                'subtitle_always_on_top'.tr(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        ValueListenableBuilder(
          valueListenable: valueNotifierAlwaysOnTop,
          builder: (BuildContext context, bool value, _) {
            return Switch.adaptive(
              value: value,
              onChanged: (newValue) async {
                if (newValue) {
                  await windowManager.setAlwaysOnTop(newValue);
                } else {
                  await windowManager.setAlwaysOnTop(newValue);
                }
                sharedPreferencesManager.putBool(
                  SharedPreferencesManager.keyIsAlwaysOnTop,
                  newValue,
                );
                valueNotifierAlwaysOnTop.value = newValue;
              },
              activeColor: Theme.of(context).colorScheme.primary,
            );
          },
        ),
      ],
    );
  }

  Widget buildWidgetScreenshotNotification() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'screenshot'.tr(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                'subtitle_screenshot_notification'.tr(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        ValueListenableBuilder(
          valueListenable: valueNotifierIsEnableScreenshotNotification,
          builder: (BuildContext context, bool value, _) {
            return Switch.adaptive(
              value: value,
              onChanged: (newValue) {
                sharedPreferencesManager.putBool(
                  SharedPreferencesManager.keyIsEnableScreenshotNotification,
                  newValue,
                );
                valueNotifierIsEnableScreenshotNotification.value = newValue;
              },
              activeColor: Theme.of(context).colorScheme.primary,
            );
          },
        ),
      ],
    );
  }

  Widget buildWidgetPlaySoundScreenshotNotification() {
    return Row(
      children: [
        SizedBox(
          width: 24,
          child: ValueListenableBuilder(
            valueListenable: valueNotifierIsEnableSoundScreenshotNotification,
            builder: (BuildContext context, bool isEnable, _) {
              return Checkbox(
                value: isEnable,
                onChanged: (newValue) {
                  if (newValue != null) {
                    valueNotifierIsEnableSoundScreenshotNotification.value = newValue;
                    sharedPreferencesManager.putBool(
                      SharedPreferencesManager.keyIsEnableSoundScreenshotNotification,
                      newValue,
                    );
                  }
                },
              );
            },
          ),
        ),
        const SizedBox(width: 4),
        Text(
          'play_sound'.tr(),
        ),
      ],
    );
  }

  Widget buildWidgetMember() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'members'.tr(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                'add_edit_or_remove_member'.tr(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () {
            context.pushNamed(MemberSettingPage.routeName);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildWidgetProject() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'projects'.tr(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                'add_edit_or_remove_project'.tr(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () {
            // TODO: Arahkan ke halaman project_setting_page.dart
            widgetHelper.showSnackBar(context, 'coming_soon'.tr());
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildWidgetTask() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'tasks_2'.tr(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                'add_edit_or_remove_task'.tr(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () {
            // TODO: Arahkan ke halaman task_setting_page.dart
            widgetHelper.showSnackBar(context, 'coming_soon'.tr());
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildWidgetDiscordChannelId() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'discord_channel_id'.tr(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                'subtitle_discord_channel_id'.tr(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () {
            context.pushNamed(SettingDiscordPage.routeName);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildWidgetMemberBlurScreenshot() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'screenshot_blur'.tr(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                'subtitle_screenshot_blur'.tr(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () {
            context.pushNamed(SettingMemberBlurScreenshotPage.routeName);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  void updateReminderTrack() async {
    final isEnableReminderNotTrack = valueNotifierIsEnableReminderTrack.value;
    await sharedPreferencesManager.putBool(SharedPreferencesManager.keyIsEnableReminderTrack, isEnableReminderNotTrack);

    final strStart = controllerStartTimeReminderTrackNotification.text.trim();
    if (strStart.contains(':') && strStart.split(':').length == 2) {
      final splitStrStart = strStart.split(':');
      final strStartHour = splitStrStart.first;
      final strStartMinute = splitStrStart.last;
      final startHour = int.tryParse(strStartHour);
      final startMinute = int.tryParse(strStartMinute);
      if (startHour != null && startMinute != null) {
        var formattedStart = startHour < 10 ? '0$startHour' : startHour.toString();
        formattedStart += ':';
        formattedStart += startMinute < 10 ? '0$startMinute' : startMinute.toString();
        await sharedPreferencesManager.putString(
          SharedPreferencesManager.keyStartTimeReminderTrack,
          formattedStart,
        );
      }
    }

    final strFinish = controllerFinishTimeReminderTrackNotification.text.trim();
    if (strFinish.contains(':') && strFinish.split(':').length == 2) {
      final splitStrFinish = strFinish.split(':');
      final strFinishHour = splitStrFinish.first;
      final strFinishMinute = splitStrFinish.last;
      final finishHour = int.tryParse(strFinishHour);
      final finishMinute = int.tryParse(strFinishMinute);
      if (finishHour != null && finishMinute != null) {
        var formattedFinish = finishHour < 10 ? '0$finishHour' : finishHour.toString();
        formattedFinish += ':';
        formattedFinish += finishMinute < 10 ? '0$finishMinute' : finishMinute.toString();
        await sharedPreferencesManager.putString(
          SharedPreferencesManager.keyFinishTimeReminderTrack,
          formattedFinish,
        );
      }
    }

    final reminderDays = <String>[];
    if (isEnableReminderTrackMon) {
      reminderDays.add(DateTime.monday.toString());
    }
    if (isEnableReminderTrackTue) {
      reminderDays.add(DateTime.tuesday.toString());
    }
    if (isEnableReminderTrackWed) {
      reminderDays.add(DateTime.wednesday.toString());
    }
    if (isEnableReminderTrackThu) {
      reminderDays.add(DateTime.thursday.toString());
    }
    if (isEnableReminderTrackFri) {
      reminderDays.add(DateTime.friday.toString());
    }
    if (isEnableReminderTrackSat) {
      reminderDays.add(DateTime.saturday.toString());
    }
    if (isEnableReminderTrackSun) {
      reminderDays.add(DateTime.sunday.toString());
    }
    await sharedPreferencesManager.putStringList(
      SharedPreferencesManager.keyDayReminderTrack,
      reminderDays,
    );

    final strIntervalReminderTrack = controllerIntervalReminderTrackNotification.text.trim();
    final intervalReminderTrack = int.tryParse(strIntervalReminderTrack);
    if (intervalReminderTrack != null) {
      await sharedPreferencesManager.putInt(
        SharedPreferencesManager.keyIntervalReminderTrack,
        intervalReminderTrack,
      );
    }
    countTimeReminderTrackInSeconds = 0;
  }

  Widget buildWidgetUserSetting() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'screenshot_blur'.tr(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                'description_screenshot_blur_user'.tr(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        BlocBuilder<SettingBloc, SettingState>(
          builder: (context, state) {
            if (state is LoadingCenterSettingState || state is LoadingButtonSettingState) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: WidgetCustomCircularProgressIndicator(),
              );
            } else if ((state is FailureSettingState || state is FailureSnackBarSettingState) && userSetting == null) {
              return TextButton(
                onPressed: doLoadUserSetting,
                child: Text('refresh'.tr()),
              );
            }

            if (userSetting == null) {
              return Container();
            }

            return Switch.adaptive(
              value: userSetting?.isEnableBlurScreenshot ?? false,
              activeColor: Theme.of(context).colorScheme.primary,
              onChanged: userRole == UserRole.superAdmin
                  ? (value) {
                      final id = userSetting?.id;
                      final userId = userSetting?.userId;
                      if (id == null || userId == null) {
                        widgetHelper.showSnackBar(context, 'invalid_id_or_user_id'.tr());
                        return;
                      }

                      final body = UserSettingBody(
                        data: [
                          ItemUserSettingBody(
                            id: userSetting!.id!,
                            isEnableBlurScreenshot: value,
                            userId: userSetting!.userId!,
                          ),
                        ],
                      );
                      settingBloc.add(
                        UpdateUserSettingEvent(
                          body: body,
                        ),
                      );
                    }
                  : null,
            );
          },
        ),
      ],
    );
  }

  void doLoadUserSetting() {
    settingBloc.add(LoadUserSettingEvent());
  }
}
