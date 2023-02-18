import 'dart:async';
import 'dart:io';

import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/core/util/images.dart';
import 'package:dipantau_desktop_client/core/util/method_channel_helper.dart';
import 'package:dipantau_desktop_client/core/util/widget_helper.dart';
import 'package:dipantau_desktop_client/feature/data/model/detail_project/detail_project_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/detail_task/detail_task_response.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/home/home_bloc.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_choose_project.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_custom_circular_progress_indicator.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_error.dart';
import 'package:dipantau_desktop_client/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class HomePage extends StatefulWidget {
  static const routePath = '/home-page';
  static const routeName = 'home';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TrayListener, WindowListener {
  final homeBloc = sl<HomeBloc>();
  final helper = sl<Helper>();
  final widgetHelper = WidgetHelper();
  final keyTrayShowTimer = 'tray-show-timer';
  final keyTrayHideTimer = 'tray-hide-timer';
  final keyTrayQuitApp = 'tray-quit-app';
  final methodChannelHelper = MethodChannelHelper();
  final valueNotifierTotalTracked = ValueNotifier<int>(0);
  final valueNotifierTaskTracked = ValueNotifier<int>(0);

  DetailProjectResponse? selectedProject;
  DetailTaskResponse? selectedTask;
  var isTimerStart = false;
  var isWindowVisible = true;
  Timer? timer;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    windowManager.addListener(this);
    trayManager.addListener(this);
    setTrayIcon();
    setTrayTitle();
    setTrayContextMenu();
    doLoadData();
    super.initState();
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
            child: Padding(
              padding: EdgeInsets.all(helper.getDefaultPaddingLayout),
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is LoadingHomeState) {
                    return const WidgetCustomCircularProgressIndicator();
                  } else if (state is FailureHomeState) {
                    final errorMessage = state.errorMessage;
                    return WidgetError(message: errorMessage);
                  } else if (state is SuccessLoadDataProjectHomeState) {
                    return Column(
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
                    );
                  }
                  return Container();
                },
              ),
            ),
          ),
        ),
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
            selectedTask = null;
            isTimerStart = !isTimerStart;
            if (isTimerStart) {
              startTimer();
            } else {
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
          onPressed: () {
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
                      }
                      selectedTask = itemTask;
                      isTimerStart = true;
                      valueNotifierTaskTracked.value = itemTask.trackedInSeconds ?? 0;
                      startTimer();
                    } else {
                      selectedTask = null;
                      isTimerStart = false;
                      itemTask.trackedInSeconds = valueNotifierTaskTracked.value;
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
                            final strTrackingTimeTask = helper.convertTrackingTimeToString(valueNotifierTaskTracked.value);
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

  void startTimer() {
    stopTimer();
    increaseTimerTray();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      increaseTimerTray();
    });
  }

  void increaseTimerTray() {
    valueNotifierTotalTracked.value += 1;
    if (selectedTask != null) {
      valueNotifierTaskTracked.value += 1;
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
      methodChannelHelper.doQuitApp();
    }
  }
}
