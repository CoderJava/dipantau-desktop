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
  final sharedPreferencesManager = sl<SharedPreferencesManager>();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1)).then((_) {
      final domainApi = sharedPreferencesManager.getString(SharedPreferencesManager.keyDomainApi) ?? '';
      if (domainApi.isEmpty) {
        context.go(
          SetupCredentialPage.routePath,
          extra: {
            SetupCredentialPage.parameterIsFromSplashScreen: true,
          },
        );
        return;
      }

      final isLogin = sharedPreferencesManager.getBool(SharedPreferencesManager.keyIsLogin) ?? false;
      if (isLogin) {
        context.go(HomePage.routePath);
      } else {
        context.go(LoginPage.routePath);
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
