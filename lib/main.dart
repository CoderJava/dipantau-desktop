import 'dart:io';
import 'dart:ui';

import 'package:auto_updater/auto_updater.dart';
import 'package:dipantau_desktop_client/config/flavor_config.dart';
import 'package:dipantau_desktop_client/core/util/enum/appearance_mode.dart';
import 'package:dipantau_desktop_client/core/util/enum/global_variable.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/feature/data/model/track_user/track_user_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_profile/user_profile_response.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/appearance/appearance_bloc.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/add_member/add_edit_member_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/edit_profile/edit_profile_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/error/error_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/forgot_password/forgot_password_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/home/home_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/login/login_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/manual_tracking/manual_tracking_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/member_setting/member_setting_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/photo_view/photo_view_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/register/register_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/register_success/register_success_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/report_screenshot/report_screenshot_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/reset_password/reset_password_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/reset_password_success/reset_password_success_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/setting/setting_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/setting_discord/setting_discord_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/setting_member_blur_screenshot/setting_member_blur_screenshot_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/setup_credential/setup_credential_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/splash/splash_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/sync/sync_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/user_registration_setting/user_registration_setting_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/verify_forgot_password/verify_forgot_password_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_custom_circular_progress_indicator.dart';
import 'package:dipantau_desktop_client/injection_container.dart' as di;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

// TODO: buat fitur khusus untuk super admin. Super admin memiliki fitur berikut:
/**
 * 1. CRUD user
 *    - add [done]
 *    - edit [done]
 *    - delete
 * 2. CRUD projek
 * 3. CRUD task
 * 4. CRUD track manual
 * 5. Report screenshot all member (done)
 * 6. Atur discord channel ID (done)
 */

// TODO: buat fitur khusus untuk admin. Admin memiliki fitur berikut:
/**
 * 1. Read projek
 * 2. add/edit/view task all member
 * 3. CRUD track manual
 * 4. Report screenshot all member (done)
 */

// TODO: buat fitur khusus untuk employee. Employee memiliki fitur berikut:
/// 1. Read assigned project
/// 2. add/edit/view personal
/// 3. CRUD personal
/// 4. Report screenshot personal (done)
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Auto updater
  const feedURL = autoUpdaterUrl;
  autoUpdater.setFeedURL(feedURL);
  autoUpdater.setScheduledCheckInterval(3600);

  packageInfo = await PackageInfo.fromPlatform();

  // Launch at startup
  launchAtStartup.setup(
    appName: packageInfo.appName,
    appPath: Platform.resolvedExecutable,
  );

  // Easy localization
  await EasyLocalization.ensureInitialized();

  // Service locator
  di.init();
  di.sl.allowReassignment = true;

  // Window manager
  const defaultWindowSize = 500.0;
  await windowManager.ensureInitialized();
  const windowSize = Size(defaultWindowSize, defaultWindowSize);
  const windowOptions = WindowOptions(
    size: windowSize,
    center: true,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    title: 'Dipantau',
  );
  windowManager.setMinimumSize(windowSize);
  windowManager.setMaximumSize(windowSize);
  windowManager.setPosition(const Offset(0, 0));
  windowManager.waitUntilReadyToShow(
    windowOptions,
    () async {
      await windowManager.show();
      await windowManager.focus();
    },
  );

  runApp(
    FutureBuilder(
      future: di.sl.allReady(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? EasyLocalization(
                supportedLocales: const [
                  Locale('en', 'US'),
                ],
                path: 'assets/translations',
                fallbackLocale: const Locale('en', 'US'),
                child: MyApp(),
              )
            : const WidgetCustomCircularProgressIndicator();
      },
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final appearanceBloc = AppearanceBloc();
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: SplashPage.routeName,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: HomePage.routePath,
        name: HomePage.routeName,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: LoginPage.routePath,
        name: LoginPage.routeName,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RegisterPage.routePath,
        name: RegisterPage.routeName,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: RegisterSuccessPage.routePath,
        name: RegisterSuccessPage.routeName,
        builder: (context, state) => RegisterSuccessPage(
          email: state.uri.queryParameters['email'] as String,
        ),
      ),
      GoRoute(
        path: ForgotPasswordPage.routePath,
        name: ForgotPasswordPage.routeName,
        builder: (context, state) => ForgotPasswordPage(
          email: state.uri.queryParameters['email'],
        ),
      ),
      GoRoute(
        path: ResetPasswordSuccessPage.routePath,
        name: ResetPasswordSuccessPage.routeName,
        builder: (context, state) => ResetPasswordSuccessPage(),
      ),
      GoRoute(
        path: SetupCredentialPage.routePath,
        name: SetupCredentialPage.routeName,
        builder: (context, state) {
          final arguments = state.extra as Map<String, dynamic>?;
          final isFromSplashScreen =
              arguments != null && arguments.containsKey(SetupCredentialPage.parameterIsFromSplashScreen)
                  ? arguments[SetupCredentialPage.parameterIsFromSplashScreen] as bool
                  : false;
          final isShowWarning = arguments != null && arguments.containsKey(SetupCredentialPage.parameterIsShowWarning)
              ? arguments[SetupCredentialPage.parameterIsShowWarning] as bool
              : false;
          return SetupCredentialPage(
            isFromSplashScreen: isFromSplashScreen,
            isShowWarning: isShowWarning,
          );
        },
      ),
      GoRoute(
        path: SettingPage.routePath,
        name: SettingPage.routeName,
        builder: (context, state) => const SettingPage(),
      ),
      GoRoute(
        path: SyncPage.routePath,
        name: SyncPage.routeName,
        builder: (context, state) => const SyncPage(),
      ),
      GoRoute(
        path: PhotoViewPage.routePath,
        name: PhotoViewPage.routeName,
        builder: (context, state) {
          final arguments = state.extra as Map<String, dynamic>?;
          final listPhotos = arguments != null && arguments.containsKey(PhotoViewPage.parameterListPhotos)
              ? arguments[PhotoViewPage.parameterListPhotos] as List<ItemFileTrackUserResponse>?
              : null;
          final isShowIconDownload =
              arguments != null && arguments.containsKey(PhotoViewPage.parameterIsShowIconDownload)
                  ? arguments[PhotoViewPage.parameterIsShowIconDownload] as bool?
                  : null;
          return PhotoViewPage(
            listPhotos: listPhotos,
            isShowIconDownload: isShowIconDownload,
          );
        },
      ),
      GoRoute(
        path: MemberSettingPage.routePath,
        name: MemberSettingPage.routeName,
        builder: (context, state) => const MemberSettingPage(),
      ),
      GoRoute(
        path: AddEditMemberPage.routePath,
        name: AddEditMemberPage.routeName,
        builder: (context, state) {
          final arguments = state.extra as Map<String, dynamic>?;
          final defaultValue = arguments != null && arguments.containsKey(AddEditMemberPage.parameterDefaultValue)
              ? arguments[AddEditMemberPage.parameterDefaultValue] as UserProfileResponse?
              : null;
          return AddEditMemberPage(defaultValue: defaultValue);
        },
      ),
      GoRoute(
        path: ReportScreenshotPage.routePath,
        name: ReportScreenshotPage.routeName,
        builder: (context, state) => const ReportScreenshotPage(),
      ),
      GoRoute(
        path: SettingDiscordPage.routePath,
        name: SettingDiscordPage.routeName,
        builder: (context, state) => const SettingDiscordPage(),
      ),
      GoRoute(
        path: EditProfilePage.routePath,
        name: EditProfilePage.routeName,
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: VerifyForgotPasswordPage.routePath,
        name: VerifyForgotPasswordPage.routeName,
        builder: (context, state) {
          final arguments = state.extra as Map<String, dynamic>?;
          final email = arguments != null && arguments.containsKey(VerifyForgotPasswordPage.parameterEmail)
              ? arguments[VerifyForgotPasswordPage.parameterEmail] as String
              : '';
          return VerifyForgotPasswordPage(email: email);
        },
      ),
      GoRoute(
        path: ResetPasswordPage.routePath,
        name: ResetPasswordPage.routeName,
        builder: (context, state) {
          final arguments = state.extra as Map<String, dynamic>?;
          final code = arguments != null && arguments.containsKey(ResetPasswordPage.parameterCode)
              ? arguments[ResetPasswordPage.parameterCode] as String
              : '';
          return ResetPasswordPage(code: code);
        },
      ),
      GoRoute(
        path: ManualTrackingPage.routePath,
        name: ManualTrackingPage.routeName,
        builder: (context, state) {
          return const ManualTrackingPage();
        },
      ),
      GoRoute(
        path: SettingMemberBlurScreenshotPage.routePath,
        name: SettingMemberBlurScreenshotPage.routeName,
        builder: (context, state) {
          return const SettingMemberBlurScreenshotPage();
        },
      ),
      GoRoute(
        path: UserRegistrationSettingPage.routePath,
        name: UserRegistrationSettingPage.routeName,
        builder: (context, state) {
          return const UserRegistrationSettingPage();
        },
      ),
    ],
    errorBuilder: (context, state) => const ErrorPage(),
  );

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final sharedPreferences = await SharedPreferences.getInstance();
      final sharedPreferencesManager = SharedPreferencesManager.getInstance(sharedPreferences);
      if (sharedPreferencesManager.isKeyExists(SharedPreferencesManager.keyDomainApi)) {
        final domainApi = sharedPreferencesManager.getString(SharedPreferencesManager.keyDomainApi) ?? '';
        if (domainApi.isNotEmpty) {
          FlavorConfig(
            values: FlavorValues(
              baseUrl: domainApi,
              baseUrlAuth: '$domainApi/api/auth',
              baseUrlUser: '$domainApi/api/user',
              baseUrlTrack: '$domainApi/api/track',
              baseUrlProject: '$domainApi/api/project',
              baseUrlSetting: '$domainApi/api/setting',
              baseUrlScreenshot: '$domainApi/api/screenshot',
            ),
          );
        }
      }

      if (mounted) {
        final window = View.of(context);
        updateAppearanceMode(window, sharedPreferencesManager);
        window.platformDispatcher.onPlatformBrightnessChanged = () {
          WidgetsBinding.instance.handlePlatformBrightnessChanged();

          // Callback ini akan selalu terpanggil ketika host system mengalami perubahan theme
          // Callback ini akan diimplementasikan jika si user pilih pengaturan appearance di app-nya ialah system
          updateAppearanceMode(window, sharedPreferencesManager);
        };
      }

      // set default launch at startup
      final isLaunchAtStartupExists =
          sharedPreferencesManager.isKeyExists(SharedPreferencesManager.keyIsLaunchAtStartup);
      if (!isLaunchAtStartupExists) {
        await launchAtStartup.enable();
        sharedPreferencesManager.putBool(SharedPreferencesManager.keyIsLaunchAtStartup, true);
      }

      // set default value always on top
      final isAlwaysOnTop =
          sharedPreferencesManager.getBool(SharedPreferencesManager.keyIsAlwaysOnTop, defaultValue: true) ?? true;
      windowManager.setAlwaysOnTop(isAlwaysOnTop);

      // set default value reminder not track
      if (!sharedPreferencesManager.isKeyExists(SharedPreferencesManager.keyIsEnableReminderTrack)) {
        sharedPreferencesManager.putBool(SharedPreferencesManager.keyIsEnableReminderTrack, false);
      }
      if (!sharedPreferencesManager.isKeyExists(SharedPreferencesManager.keyStartTimeReminderTrack)) {
        sharedPreferencesManager.putString(SharedPreferencesManager.keyStartTimeReminderTrack, '08:30');
      }
      if (!sharedPreferencesManager.isKeyExists(SharedPreferencesManager.keyFinishTimeReminderTrack)) {
        sharedPreferencesManager.putString(SharedPreferencesManager.keyFinishTimeReminderTrack, '17:00');
      }
      if (!sharedPreferencesManager.isKeyExists(SharedPreferencesManager.keyDayReminderTrack)) {
        final defaultDays = [
          DateTime.monday.toString(),
          DateTime.tuesday.toString(),
          DateTime.wednesday.toString(),
          DateTime.thursday.toString(),
          DateTime.friday.toString(),
        ];
        sharedPreferencesManager.putStringList(SharedPreferencesManager.keyDayReminderTrack, defaultDays);
      }
      if (!sharedPreferencesManager.isKeyExists(SharedPreferencesManager.keyIntervalReminderTrack)) {
        // 15 menit
        sharedPreferencesManager.putInt(SharedPreferencesManager.keyIntervalReminderTrack, 15);
      }
    });
    super.initState();
  }

  void updateAppearanceMode(FlutterView window, SharedPreferencesManager sharedPreferencesManager) {
    final strAppearanceMode =
        sharedPreferencesManager.getString(SharedPreferencesManager.keyAppearanceMode) ?? AppearanceMode.light.name;
    final appearanceMode = strAppearanceMode.fromStringAppearanceMode;
    if (appearanceMode != null) {
      switch (appearanceMode) {
        case AppearanceMode.light:
          appearanceBloc.add(UpdateAppearanceEvent(isDarkMode: false));
          break;
        case AppearanceMode.dark:
          appearanceBloc.add(UpdateAppearanceEvent(isDarkMode: true));
          break;
        case AppearanceMode.system:
          final brightness = window.platformDispatcher.platformBrightness;
          appearanceBloc.add(UpdateAppearanceEvent(isDarkMode: brightness == Brightness.dark));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppearanceBloc>(
      create: (context) => appearanceBloc,
      child: BlocBuilder<AppearanceBloc, AppearanceState>(
        builder: (context, state) {
          var isDarkMode = false;
          if (state is UpdatedAppearanceState) {
            isDarkMode = state.isDarkMode;
          }

          return PopScope(
            canPop: false,
            onPopInvoked: (didPop) {
              if (didPop) {
                return;
              }
              return;
            },
            child: MaterialApp.router(
              title: 'Dipantau',
              themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
              theme: lightTheme(),
              darkTheme: darkTheme(),
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              routerConfig: router,
              debugShowCheckedModeBanner: false,
            ),
          );
        },
      ),
    );
  }

  ThemeData lightTheme() {
    final baseTheme = ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      useMaterial3: true,
    );
    return baseTheme.copyWith(
      textTheme: GoogleFonts.ubuntuTextTheme(baseTheme.textTheme),
      /*colorScheme: const ColorScheme.light(
        primary: Color(0xff6750a4),
        secondary: Color(0xff625b71),
      ),*/
    );
  }

  ThemeData darkTheme() {
    final baseTheme = ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      useMaterial3: true,
    );
    return baseTheme.copyWith(
      textTheme: GoogleFonts.ubuntuTextTheme(baseTheme.textTheme),
      /*colorScheme: const ColorScheme.dark(
        primary: Color(0xff6750a4),
        secondary: Color(0xffccc2dc),
      ),*/
    );
  }
}
