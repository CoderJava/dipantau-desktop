import 'package:dipantau_desktop_client/core/util/enum/appearance_mode.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/appearance/appearance_bloc.dart';
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

class SettingPage extends StatefulWidget {
  static const routePath = '/setting';
  static const routeName = 'setting';

  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final helper = sl<Helper>();
  final sharedPreferencesManager = sl<SharedPreferencesManager>();
  final valueNotifierIsEnableScreenshotNotification = ValueNotifier(false);
  final valueNotifierAppearanceMode = ValueNotifier(AppearanceMode.light);

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
    appearanceBloc = BlocProvider.of<AppearanceBloc>(context);
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
    final appearanceMode = strAppearanceMode.fromString;
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
          ),
          children: [
            buildWidgetScreenshotNotification(),
            const SizedBox(height: 16),
            buildWidgetSetHostName(),
            const SizedBox(height: 16),
            buildWidgetChooseAppearance(),
            const SizedBox(height: 24),
            buildWidgetButtonLogout(),
          ],
        ),
      ),
    );
  }

  Widget buildWidgetScreenshotNotification() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'screenshot_notification'.tr(),
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

  Widget buildWidgetSetHostName() {
    return Row(
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
                '${'current'.tr()}: $hostname',
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

  Widget buildWidgetChooseAppearance() {
    const height = 128.0;
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
}
