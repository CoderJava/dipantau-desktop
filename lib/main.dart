import 'package:dipantau_desktop_client/config/flavor_config.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/home/home_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/login/login_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/register/register_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/register_success/register_success_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/reset_password/reset_password_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/reset_password_success/reset_password_success_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/splash/splash_page.dart';
import 'package:dipantau_desktop_client/firebase_options.dart';
import 'package:dipantau_desktop_client/injection_container.dart' as di;
import 'package:dipantau_desktop_client/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Easy localization
  await EasyLocalization.ensureInitialized();

  // Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Service locator
  await di.init();

  // Window manager
  final helper = sl<Helper>();
  final defaultWindowSize = helper.getDefaultWindowSize;
  await windowManager.ensureInitialized();
  final windowSize = Size(defaultWindowSize, defaultWindowSize);
  final windowOptions = WindowOptions(
    size: windowSize,
    center: true,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );
  windowManager.setMinimumSize(windowSize);
  windowManager.setMaximumSize(windowSize);
  // windowManager.setPosition(const Offset(0, 0)); // Comment jika mode production
  windowManager.waitUntilReadyToShow(
    windowOptions,
    () async {
      await windowManager.show();
      await windowManager.focus();
    },
  );

  const baseUrl = 'http://localhost:8080';

  // Flavor config
  FlavorConfig(
    values: FlavorValues(
      baseUrl: baseUrl,
      baseUrlAuth: '$baseUrl/auth',
      baseUrlUser: '$baseUrl/user',
    ),
  );

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
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
          email: state.queryParams['email'] as String,
        ),
      ),
      GoRoute(
        path: ResetPasswordPage.routePath,
        name: ResetPasswordPage.routeName,
        builder: (context, state) => ResetPasswordPage(
          email: state.queryParams['email'],
        ),
      ),
      GoRoute(
        path: ResetPasswordSuccessPage.routePath,
        name: ResetPasswordSuccessPage.routeName,
        builder: (context, state) => ResetPasswordSuccessPage(
          email: state.queryParams['email'] ?? '',
        ),
      ),
    ],
  );

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Dipantau',
      theme: buildTheme(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }

  ThemeData buildTheme() {
    final baseTheme = ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      useMaterial3: true,
    );
    return baseTheme.copyWith(
      textTheme: GoogleFonts.ubuntuTextTheme(baseTheme.textTheme),
    );
  }
}
