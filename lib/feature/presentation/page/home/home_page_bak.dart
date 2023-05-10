import 'dart:async';
import 'dart:io';

import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/core/util/images.dart';
import 'package:dipantau_desktop_client/core/util/notification_helper.dart';
import 'package:dipantau_desktop_client/core/util/platform_channel_helper.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/core/util/widget_helper.dart';
import 'package:dipantau_desktop_client/feature/data/model/detail_project/detail_project_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/detail_task/detail_task_response.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/home/home_bloc.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/splash/splash_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_choose_project.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_custom_circular_progress_indicator.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_error.dart';
import 'package:dipantau_desktop_client/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class HomePageBak extends StatefulWidget {
  static const routePath = '/home-page';
  static const routeName = 'home';

  const HomePageBak({Key? key}) : super(key: key);

  @override
  State<HomePageBak> createState() => _HomePageBakState();
}

class _HomePageBakState extends State<HomePageBak> with TrayListener, WindowListener {
  final homeBloc = sl<HomeBloc>();
  final helper = sl<Helper>();
  final widgetHelper = WidgetHelper();
  final keyTrayShowTimer = 'tray-show-timer';
  final keyTrayHideTimer = 'tray-hide-timer';
  final keyTrayQuitApp = 'tray-quit-app';
  final platformChannelHelper = PlatformChannelHelper();
  final valueNotifierTotalTracked = ValueNotifier<int>(0);
  final valueNotifierTaskTracked = ValueNotifier<int>(0);
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final notificationHelper = sl<NotificationHelper>();
  final intervalScreenshot = 60 * 5; // 300 detik (5 menit)
  final sharedPreferencesManager = sl<SharedPreferencesManager>();

  DetailProjectResponse? selectedProject;
  DetailTaskResponse? selectedTask;
  var isTimerStart = false;
  var isWindowVisible = true;
  Timer? timer;
  var countTimerInSeconds = 0;
  var isHaveActivity = false;
  var counterActivity = 0;
  DateTime? startTime;
  DateTime? endTime;
  var email = '';

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    email = sharedPreferencesManager.getString(SharedPreferencesManager.keyEmail) ?? '-';
    windowManager.addListener(this);
    trayManager.addListener(this);
    setTrayIcon();
    setTrayTitle();
    setTrayContextMenu();
    doStartActivityListener();
    notificationHelper.requestPermissionNotification();
    doLoadData();
    super.initState();
  }

  void doStartActivityListener() {
    platformChannelHelper.setActivityListener();
    platformChannelHelper.startEventChannel().listen((Object? event) {
      if (event != null) {
        if (event is String) {
          isHaveActivity = true;
        }
      }
    });
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    trayManager.removeListener(this);
    super.dispose();
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<HomeBloc>(
        create: (context) => homeBloc,
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is SuccessLoadDataProjectHomeState) {
              final project = state.project;
              final listProjects = project.data;
              if (listProjects.isNotEmpty) {
                selectedProject = listProjects.first;
              }
              if (selectedProject != null) {
                valueNotifierTotalTracked.value = selectedProject?.trackedInSeconds ?? 0;
                final strTotalTrackingTime = helper.convertTrackingTimeToString(valueNotifierTotalTracked.value);
                setTrayTitle(title: strTotalTrackingTime);
              } else {
                setTrayTitle();
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
                    child: WidgetError(message: errorMessage),
                  );
                } else if (state is SuccessLoadDataProjectHomeState) {
                  return Column(
                    children: [
                      Container(
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
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: helper.getDefaultPaddingLayout,
                            top: helper.getDefaultPaddingLayout,
                            right: helper.getDefaultPaddingLayout,
                            bottom: helper.getDefaultPaddingLayout,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              buildWidgetFieldProject(),
                              const SizedBox(height: 24),
                              buildWidgetTimer(),
                              const SizedBox(height: 24),
                              buildWidgetButtonTimer(),
                              const SizedBox(height: 24),
                              Expanded(
                                child: buildWidgetListTasks(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
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

  Widget buildWidgetFieldProject() {
    return Material(
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: isTimerStart
            ? null
            : () async {
                final selectedProjectId = selectedProject?.id;
                final chooseProject = await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  enableDrag: false,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  builder: (context) => WidgetChooseProject(
                    defaultSelectedProjectId: selectedProjectId,
                  ),
                ) as DetailProjectResponse?;
                if (chooseProject != null) {
                  selectedProject = chooseProject;
                  valueNotifierTotalTracked.value = selectedProject?.trackedInSeconds ?? 0;
                  setState(() {});
                }
              },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isTimerStart ? Colors.green : Colors.grey,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  selectedProject?.name ?? 'choose_project'.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 16),
              isTimerStart
                  ? Container()
                  : const Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildWidgetTimer() {
    return ValueListenableBuilder(
      valueListenable: valueNotifierTotalTracked,
      builder: (BuildContext context, int value, _) {
        final strTrackingTime = helper.convertTrackingTimeToString(value);
        return Text(
          strTrackingTime,
          style: Theme.of(context).textTheme.displayMedium,
          textAlign: TextAlign.center,
        );
      },
    );
  }

  Widget buildWidgetButtonTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            if (selectedTask != null) {
              selectedTask?.trackedInSeconds = valueNotifierTaskTracked.value;
            }
            isTimerStart = !isTimerStart;
            if (isTimerStart) {
              resetCountTimer();
              startTime = DateTime.now();
              if (selectedProject == null) {
                widgetHelper.showSnackBar(context, 'please_choose_a_project'.tr());
                return;
              }
              final generalTask = (selectedProject!.listTasks ?? [])
                  .where((element) => (element.name ?? '').toLowerCase() == 'general');
              if (generalTask.isEmpty) {
                widgetHelper.showSnackBar(context, 'general_task_not_found'.tr());
                return;
              }
              selectedTask = generalTask.first;
              valueNotifierTaskTracked.value = selectedTask!.trackedInSeconds ?? 0;
              startTimer();
            } else {
              doTakeScreenshot();
              endTime = DateTime.now();
              debugPrint('start time: $startTime & end time: $endTime');
              // TODO: Simpan data tracking ke lokal
              selectedTask = null;
              stopTimer();
            }
            setState(() {});
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            elevation: 0,
            padding: const EdgeInsets.all(16),
          ),
          child: Icon(
            isTimerStart ? Icons.pause : Icons.play_arrow,
            size: 32,
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            // TODO: Buat fitur add new task
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
          ),
          child: const Icon(
            Icons.add,
            size: 32,
          ),
        ),
      ],
    );
  }

  void doTakeScreenshot() {
    platformChannelHelper.doTakeScreenshot();
    notificationHelper.showScreenshotTakenNotification();
    var percentActivity = 0.0;
    if (counterActivity > 0) {
      // percentActivity = (counterActivity / intervalScreenshot) * 100;
      percentActivity = (counterActivity / countTimerInSeconds) * 100;
    }
    counterActivity = 0;
  }

  Widget buildWidgetListTasks() {
    final now = DateTime.now();
    final formattedNow = helper.setDateFormat('EEE, dd MMM yyyy').format(now);
    final listTasks = selectedProject?.listTasks ?? [];
    if (listTasks.isEmpty) {
      return WidgetError(message: 'no_data_to_display'.tr());
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'tasks'.plural(
                listTasks.length,
                args: listTasks.isEmpty
                    ? []
                    : [
                        listTasks.length.toString(),
                      ],
              ),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            Text(
              formattedNow,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
        Expanded(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final itemTask = listTasks[index];
                final strTrackingTime = helper.convertTrackingTimeToString(itemTask.trackedInSeconds ?? 0);
                final isStart = (itemTask.id ?? -1) == (selectedTask?.id ?? -2);
                final activeColor = Theme.of(context).primaryColor;

                return InkWell(
                  onTap: () {
                    if (selectedTask != itemTask) {
                      if (selectedTask != null) {
                        selectedTask!.trackedInSeconds = valueNotifierTaskTracked.value;
                        doTakeScreenshot();
                        endTime = DateTime.now();
                        debugPrint('start time: $startTime & end time: $endTime');
                        // TODO: Simpan data tracking ke lokal
                      }
                      selectedTask = itemTask;
                      isTimerStart = true;
                      valueNotifierTaskTracked.value = itemTask.trackedInSeconds ?? 0;
                      startTime = DateTime.now();
                      resetCountTimer();
                      startTimer();
                    } else {
                      selectedTask = null;
                      isTimerStart = false;
                      itemTask.trackedInSeconds = valueNotifierTaskTracked.value;
                      doTakeScreenshot();
                      endTime = DateTime.now();
                      debugPrint('start time: $startTime & end time: $endTime');
                      // TODO: Simpan data tracking ke lokal
                      stopTimer();
                    }
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            itemTask.name ?? '-',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: isStart ? activeColor : Colors.grey[900],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ValueListenableBuilder(
                          valueListenable: valueNotifierTaskTracked,
                          builder: (BuildContext context, int value, Widget? child) {
                            if (!isStart) {
                              return child ?? Container();
                            }
                            final strTrackingTimeTask =
                                helper.convertTrackingTimeToString(valueNotifierTaskTracked.value);
                            return Text(
                              strTrackingTimeTask,
                              style: TextStyle(
                                color: activeColor,
                              ),
                            );
                          },
                          child: Text(
                            strTrackingTime,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          isStart ? Icons.pause_circle : Icons.play_circle,
                          color: isStart ? activeColor : Colors.grey,
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(height: 1);
              },
              itemCount: listTasks.length,
            ),
          ),
        ),
      ],
    );
  }

  void resetCountTimer() {
    countTimerInSeconds = 0;
  }

  void startTimer() {
    stopTimer();
    increaseTimerTray();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      increaseTimerTray();
    });
  }

  void increaseTimerTray() {
    if (isHaveActivity) {
      counterActivity += 1;
    }
    isHaveActivity = false;
    valueNotifierTotalTracked.value += 1;
    countTimerInSeconds += 1;
    if (selectedTask != null) {
      valueNotifierTaskTracked.value += 1;
    }
    if (countTimerInSeconds == intervalScreenshot) {
      resetCountTimer();
      doTakeScreenshot();
    }
    final strTrackingTimeTemp = helper.convertTrackingTimeToString(valueNotifierTotalTracked.value);
    setTrayTitle(title: strTrackingTimeTemp);
  }

  void stopTimer() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
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
}
