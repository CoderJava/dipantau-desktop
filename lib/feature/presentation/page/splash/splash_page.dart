import 'package:dipantau_desktop_client/feature/presentation/page/home/home_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/login/login_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_custom_circular_progress_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    Future.delayed(const Duration(seconds: 1)).then((_) {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        // Jika belum login maka, arahkan ke halaman login_page.dart
        context.go(LoginPage.routePath);
      } else {
        // Jika sudah login maka, arahkan ke halaman home_page.dart
        context.go(HomePage.routePath);
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
