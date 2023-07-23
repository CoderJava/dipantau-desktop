import 'package:auto_updater/auto_updater.dart';
import 'package:dipantau_desktop_client/core/util/enum/appearance_mode.dart';
import 'package:dipantau_desktop_client/core/util/enum/global_variable.dart';
import 'package:dipantau_desktop_client/core/util/enum/user_role.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/core/util/widget_helper.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/appearance/appearance_bloc.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/member_setting/member_setting_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/setting_discord/setting_discord_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/setup_credential/setup_credential_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/splash/splash_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_primary_button.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_theme_container.dart';
import 'package:dipantau_desktop_client/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
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
  final helper = sl<Helper>();
  final navigationRailDestinations = <NavigationRailDestination>[];
  final sharedPreferencesManager = sl<SharedPreferencesManager>();
  final valueNotifierIsEnableScreenshotNotification = ValueNotifier(false);
  final valueNotifierAppearanceMode = ValueNotifier(AppearanceMode.light);
  final valueNotifierLaunchAtStartup = ValueNotifier(true);
  final valueNotifierAlwaysOnTop = ValueNotifier(true);
  final widgetHelper = WidgetHelper();

  var selectedIndexNavigationRail = 0;
  UserRole? userRole;
  var hostname = '';
  late AppearanceBloc appearanceBloc;

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setupNavigationRailDestinations();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ],
    );
  }

  void prepareData() {
    valueNotifierIsEnableScreenshotNotification.value =
        sharedPreferencesManager.getBool(SharedPreferencesManager.keyIsEnableScreenshotNotification) ?? false;
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
}

/*class _SettingPageState extends State<SettingPage> {
  final helper = sl<Helper>();
  final valueNotifierIsEnableScreenshotNotification = ValueNotifier(false);
  final valueNotifierAppearanceMode = ValueNotifier(AppearanceMode.light);
  final valueNotifierLaunchAtStartup = ValueNotifier(true);
  final widgetHelper = WidgetHelper();
  final sharedPreferencesManager = sl<SharedPreferencesManager>();

  var hostname = '';
  late AppearanceBloc appearanceBloc;
  UserRole? userRole;

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
    super.initState();
  }

  void prepareData() {
    valueNotifierIsEnableScreenshotNotification.value =
        sharedPreferencesManager.getBool(SharedPreferencesManager.keyIsEnableScreenshotNotification) ?? false;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('setting'.tr()),
        centerTitle: false,
      ),
      body: SizedBox(
        width: double.infinity,
        child: ListView(
          padding: EdgeInsets.only(
            left: helper.getDefaultPaddingLayout,
            top: helper.getDefaultPaddingLayoutTop,
            right: helper.getDefaultPaddingLayout,
            bottom: helper.getDefaultPaddingLayout + 8,
          ),
          children: [
            Text(
              'general'.tr(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            buildWidgetScreenshotNotification(),
            const SizedBox(height: 16),
            buildWidgetLaunchAtStartup(),
            const SizedBox(height: 16),
            buildWidgetSetHostName(),
            const SizedBox(height: 16),
            buildWidgetCheckForUpdate(),
            const SizedBox(height: 16),
            buildWidgetChooseAppearance(),
            buildWidgetCompanySetting(),
            const SizedBox(height: 24),
            buildWidgetButtonLogout(),
          ],
        ),
      ),
    );
  }
}*/
