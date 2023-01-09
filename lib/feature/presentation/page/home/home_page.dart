import 'package:dipantau_desktop_client/feature/presentation/page/splash/splash_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_primary_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  static const routePath = '/home-page';
  static const routeName = 'home';

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: WidgetPrimaryButton(
          onPressed: () async {
            FirebaseAuth.instance.signOut().then((_) {
              context.goNamed(SplashPage.routeName);
            });
          },
          child: Text('sign_out'.tr()),
        ),
      ),
    );
  }
}
