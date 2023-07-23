import 'package:dipantau_desktop_client/core/util/enum/appearance_mode.dart';
import 'package:dipantau_desktop_client/core/util/enum/global_variable.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/home/home_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/login/login_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/setup_credential/setup_credential_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_custom_circular_progress_indicator.dart';
import 'package:dipantau_desktop_client/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  static const routePath = '/splash';
  static const routeName = 'splash';

  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1)).then((_) async {
      sharedPreferencesManager = await sl.getAsync<SharedPreferencesManager>();
      if (!sharedPreferencesManager.isKeyExists(SharedPreferencesManager.keyAppearanceMode)) {
        sharedPreferencesManager.putString(SharedPreferencesManager.keyAppearanceMode, AppearanceMode.light.name);
      }
      final domainApi = sharedPreferencesManager.getString(SharedPreferencesManager.keyDomainApi) ?? '';
      if (domainApi.isEmpty && mounted) {
        context.go(
          SetupCredentialPage.routePath,
          extra: {
            SetupCredentialPage.parameterIsFromSplashScreen: true,
          },
        );
        return;
      }

      final isLogin = sharedPreferencesManager.getBool(SharedPreferencesManager.keyIsLogin) ?? false;
      if (mounted) {
        if (isLogin) {
          context.go(HomePage.routePath);
        } else {
          context.go(LoginPage.routePath);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: WidgetCustomCircularProgressIndicator(),
      ),
    );
  }
}
