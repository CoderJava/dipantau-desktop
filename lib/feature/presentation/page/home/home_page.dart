import 'dart:io';

import 'package:dipantau_desktop_client/core/util/enum/user_role.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/core/util/images.dart';
import 'package:dipantau_desktop_client/core/util/platform_channel_helper.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/core/util/string_extension.dart';
import 'package:dipantau_desktop_client/core/util/widget_helper.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/home/home_bloc.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/splash/splash_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_custom_circular_progress_indicator.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_error.dart';
import 'package:dipantau_desktop_client/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class HomePage extends StatefulWidget {
  static const routePath = '/home';
  static const routeName = 'home';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TrayListener, WindowListener {
  final homeBloc = sl<HomeBloc>();
  final helper = sl<Helper>();
  final sharedPreferencesManager = sl<SharedPreferencesManager>();
  final widgetHelper = WidgetHelper();
  final keyTrayShowTimer = 'tray-show-timer';
  final keyTrayHideTimer = 'tray-hide-timer';
  final keyTrayQuitApp = 'tray-quit-app';
  final platformChannelHelper = PlatformChannelHelper();

  var isPrepareDataSuccess = false;
  var isWindowVisible = true;

  var email = '';
  UserRole? userRole;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    email = sharedPreferencesManager.getString(SharedPreferencesManager.keyEmail) ?? '';
    setupWindow();
    setupTray();
    doPrepareData();
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    trayManager.removeListener(this);
    super.dispose();
  }

  void setupWindow() {
    windowManager.addListener(this);
  }

  void setupTray() {
    trayManager.addListener(this);
    setTrayIcon();
    setTrayTitle();
    setTrayContextMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<HomeBloc>(
        create: (context) => homeBloc,
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is SuccessPrepareDataHomeState) {
              isPrepareDataSuccess = true;
              final user = state.user;
              if (user != null) {
                email = user.username ?? '';
                userRole = user.role;
              }
            }
          },
          child: SizedBox(
            width: double.infinity,
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is LoadingHomeState) {
                  return const WidgetCustomCircularProgressIndicator();
                } else if (state is FailureHomeState) {
                  final errorMessage = state.errorMessage;
                  return Padding(
                    padding: EdgeInsets.all(helper.getDefaultPaddingLayout),
                    child: WidgetError(
                      message: errorMessage.hideResponseCode(),
                      onTryAgain: isPrepareDataSuccess ? doLoadData : doPrepareData,
                    ),
                  );
                } else if (state is SuccessPrepareDataHomeState) {
                  return buildWidgetBody();
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildWidgetBody() {
    return Column(
      children: [
        buildWidgetHeader(),
        // TODO: lanjutkan di sini untuk membuat tampilan content-nya
      ],
    );
  }

  Widget buildWidgetHeader() {
    return Container(
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.only(
        left: 12,
        top: 8,
        right: 12,
        bottom: 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () {
                // TODO: Buat fitur view profile
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.solidCircleUser,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    buildWidgetTextEmail(),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () {
                // TODO: Buat fitur sync
              },
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(
                  Icons.sync,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () async {
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
                  sharedPreferencesManager.clearAll();
                  context.goNamed(SplashPage.routeName);
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(
                  Icons.logout,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void doPrepareData() {
    homeBloc.add(PrepareDataHomeEvent());
  }

  void doLoadData() {
    homeBloc.add(LoadDataProjectHomeEvent());
  }

  void setTrayIcon() {
    final pathIconTray = Platform.isWindows ? BaseIconTray.iconOriginalIco : BaseIconTray.iconOriginalPng;
    trayManager.setIcon(pathIconTray);
  }

  void setTrayTitle({String title = '--:--:--'}) {
    trayManager.setTitle(title);
  }

  void setTrayContextMenu() {
    final items = <MenuItem>[];
    if (isWindowVisible) {
      items.add(
        MenuItem(
          key: keyTrayHideTimer,
          label: 'hide_timer'.tr(),
        ),
      );
    } else {
      items.add(
        MenuItem(
          key: keyTrayShowTimer,
          label: 'show_timer'.tr(),
        ),
      );
    }

    items.add(MenuItem.separator());
    items.add(
      MenuItem(
        key: keyTrayQuitApp,
        label: 'quit_app'.tr(),
      ),
    );

    trayManager.setContextMenu(
      Menu(
        items: items,
      ),
    );
  }

  @override
  void onWindowEvent(String eventName) async {
    isWindowVisible = await windowManager.isVisible();
  }

  @override
  void onWindowMinimize() {
    isWindowVisible = false;
    setTrayContextMenu();
  }

  @override
  void onWindowRestore() {
    isWindowVisible = true;
    setTrayContextMenu();
  }

  @override
  void onTrayIconMouseDown() {
    setTrayContextMenu();
    trayManager.popUpContextMenu();
    super.onTrayIconMouseDown();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    final keyMenuItem = menuItem.key;
    if (keyMenuItem == keyTrayShowTimer) {
      windowManager.show();
      isWindowVisible = true;
    } else if (keyMenuItem == keyTrayHideTimer) {
      windowManager.hide();
      isWindowVisible = false;
    } else if (keyMenuItem == keyTrayQuitApp) {
      platformChannelHelper.doQuitApp();
    }
  }

  Widget buildWidgetTextEmail() {
    var strEmail = email;
    if (strEmail.length >= 30) {
      final splittedEmail = strEmail.split('@');
      var username = splittedEmail.first;
      final domain = splittedEmail.last;
      if (username.length >= 10) {
        username = username.substring(0, 10);
      }
      strEmail = '$username...@$domain';
    }
    return Text(
      strEmail,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
