import 'dart:async';
import 'dart:io';

import 'package:dipantau_desktop_client/core/util/enum/global_variable.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/core/util/images.dart';
import 'package:dipantau_desktop_client/core/util/notification_helper.dart';
import 'package:dipantau_desktop_client/core/util/platform_channel_helper.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/core/util/widget_helper.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/bulk_create_track_data_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/bulk_create_track_image_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/create_track_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/project/project_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/track_task/track_task.dart';
import 'package:dipantau_desktop_client/feature/data/model/track_user_lite/track_user_lite_response.dart';
import 'package:dipantau_desktop_client/feature/database/app_database.dart';
import 'package:dipantau_desktop_client/feature/database/entity/track/track.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/home/home_bloc.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/tracking/tracking_bloc.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/user_profile/user_profile_bloc.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/edit_profile/edit_profile_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/report_screenshot/report_screenshot_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/setting/setting_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/sync/sync_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_choose_project.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_custom_circular_progress_indicator.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_error.dart';
import 'package:dipantau_desktop_client/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
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
  final trackingBloc = sl<TrackingBloc>();
  final userProfileBloc = sl<UserProfileBloc>();
  final helper = sl<Helper>();
  final listTrackTask = <TrackTask>[];
  final widgetHelper = WidgetHelper();
  final keyTrayShowTimer = 'tray-show-timer';
  final keyTrayHideTimer = 'tray-hide-timer';
  final keyTrayQuitApp = 'tray-quit-app';
  final platformChannelHelper = PlatformChannelHelper();
  final valueNotifierTotalTracked = ValueNotifier<int>(0);
  final valueNotifierTaskTracked = ValueNotifier<int>(0);
  final flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();
  final notificationHelper = sl<NotificationHelper>();
  final intervalScreenshot = 60 * 5; // 300 detik (5 menit)
  final listTrackLocal = <Track>[];

  var isWindowVisible = true;
  var userId = '';
  var email = '';
  TrackUserLiteResponse? trackUserLite;
  var isTimerStart = false;
  ItemProjectResponse? selectedProject;
  TrackTask? selectedTask;
  Timer? timeTrack, timerCronTrack, timerDate;
  var countTimerInSeconds = 0;
  var isHaveActivity = false;
  var counterActivity = 0;
  DateTime? startTime;
  DateTime? finishTime;
  DateTime? infoDateTime;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    startTimerDate();
    doLoadDataUserProfile();
    userId = sharedPreferencesManager.getString(SharedPreferencesManager.keyUserId) ?? '';
    email = sharedPreferencesManager.getString(SharedPreferencesManager.keyEmail) ?? '';
    if (!sharedPreferencesManager.isKeyExists(SharedPreferencesManager.keyIsEnableScreenshotNotification)) {
      sharedPreferencesManager.putBool(SharedPreferencesManager.keyIsEnableScreenshotNotification, true);
    }
    initDefaultSelectedProject();
    setupWindow();
    setupTray();
    doStartActivityListener();
    checkAssetAudio();
    notificationHelper.requestPermissionNotification();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final appDatabase = await sl.getAsync<AppDatabase>();
        trackDao = appDatabase.trackDao;
      } catch (error) {
        widgetHelper.showSnackBar(context, 'error: $error');
      }
      setupCronTimer();
      doLoadData();
    });
    super.initState();
  }

  void startTimerDate() {
    final now = DateTime.now();
    infoDateTime = DateTime(
      now.year,
      now.month,
      now.day,
    );
    timerDate = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      final dateTimeNow = DateTime(
        now.year,
        now.month,
        now.day,
      );
      if (!dateTimeNow.isAtSameMomentAs(infoDateTime ?? now)) {
        infoDateTime = DateTime(
          dateTimeNow.year,
          dateTimeNow.month,
          dateTimeNow.day,
        );
        for (final element in listTrackTask) {
          element.trackedInSeconds = 0;
        }
        valueNotifierTotalTracked.value = 0;
        valueNotifierTaskTracked.value = 0;
        setState(() {});
      }
    });
  }

  void doLoadDataUserProfile() {
    userProfileBloc.add(LoadDataUserProfileEvent());
  }

  void setupCronTimer() {
    timerCronTrack = Timer.periodic(
      const Duration(minutes: 3),
      (_) async {
        BulkCreateTrackDataBody? bodyData;
        final tracks = await trackDao.findAllTrack(userId);
        final dataTrack = tracks.map((e) {
          final files = e.files;
          final listFileName = <String>[];
          if (files.contains(',')) {
            final splitFile = files.split(',');
            for (final file in splitFile) {
              final filename = file.split('/');
              listFileName.add(filename.last);
            }
          } else {
            final filename = files.split('/');
            listFileName.add(filename.last);
          }
          return ItemBulkCreateTrackDataBody(
            id: e.id,
            taskId: e.taskId,
            startDate: e.startDate,
            finishDate: e.finishDate,
            activity: e.activity,
            duration: e.duration,
            listFileName: listFileName,
          );
        }).toList();
        if (dataTrack.isNotEmpty) {
          bodyData = BulkCreateTrackDataBody(
            data: dataTrack,
          );
        }

        final directoryPath = await widgetHelper.getDirectoryApp('screenshot');
        final isDirectoryExists = Directory(directoryPath).existsSync();
        BulkCreateTrackImageBody? bodyImage;
        if (isDirectoryExists) {
          final files = <String>[];
          final directoryScreenshot = Directory(directoryPath);
          final contents = directoryScreenshot.listSync();
          var counter = 0;
          for (final itemContent in contents) {
            if (counter >= 10) {
              break;
            }

            final path = itemContent.path;
            final type = await FileSystemEntity.type(path);
            if (type != FileSystemEntityType.file) {
              continue;
            } else if (!File(path).existsSync()) {
              continue;
            }

            files.add(path);
            counter += 1;
          }
          if (files.isNotEmpty) {
            bodyImage = BulkCreateTrackImageBody(files: files);
          }
        }
        trackingBloc.add(
          CronTrackingEvent(
            bodyData: bodyData,
            bodyImage: bodyImage,
          ),
        );
      },
    );
  }

  void initDefaultSelectedProject() {
    final selectedProjectId = sharedPreferencesManager.getInt(SharedPreferencesManager.keySelectedProjectId);
    final selectedProjectName = sharedPreferencesManager.getString(SharedPreferencesManager.keySelectedProjectName);
    if (selectedProjectId != null &&
        selectedProjectId != 0 &&
        selectedProjectName != null &&
        selectedProjectName.isNotEmpty) {
      selectedProject = ItemProjectResponse(id: selectedProjectId, name: selectedProjectName);
    }
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    trayManager.removeListener(this);
    timerCronTrack?.cancel();
    timerDate?.cancel();
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
      body: MultiBlocProvider(
        providers: [
          BlocProvider<HomeBloc>(
            create: (context) => homeBloc,
          ),
          BlocProvider<TrackingBloc>(
            create: (context) => trackingBloc,
          ),
          BlocProvider<UserProfileBloc>(
            create: (context) => userProfileBloc,
          )
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<HomeBloc, HomeState>(
              listener: (context, state) async {
                if (state is FailureHomeState) {
                  final errorMessage = state.errorMessage;
                  if (errorMessage.contains('401')) {
                    widgetHelper.showDialog401(context);
                    return;
                  }
                } else if (state is SuccessLoadDataHomeState) {
                  trackUserLite = state.trackUserLiteResponse;
                  valueNotifierTotalTracked.value = trackUserLite?.trackedInSeconds ?? 0;

                  if (listTrackLocal.isNotEmpty) {
                    var totalTrackedFromLocal = 0;
                    for (final element in listTrackLocal) {
                      totalTrackedFromLocal += element.duration;
                    }
                    valueNotifierTotalTracked.value += totalTrackedFromLocal;
                  }

                  final strTotalTrackingTime = helper.convertTrackingTimeToString(valueNotifierTotalTracked.value);
                  setTrayTitle(title: strTotalTrackingTime);

                  listTrackTask.clear();
                  final listTasks = trackUserLite?.listTasks ?? [];
                  if (listTasks.isNotEmpty) {
                    listTrackTask.addAll(
                      listTasks.where((element) {
                        return element.id != null && element.name != null;
                      }).map((e) {
                        return TrackTask(
                          id: e.id!,
                          name: e.name!,
                          trackedInSeconds: 0,
                        );
                      }),
                    );
                  }

                  final listTracks = trackUserLite?.listTracks ?? [];
                  for (var index = 0; index < listTrackTask.length; index++) {
                    final element = listTrackTask[index];
                    final id = element.id;
                    var totalTrackedInSeconds = 0;
                    final filteredTracks = listTracks.where((e) => e.taskId != null && e.taskId == id);
                    for (final itemFilteredTrack in filteredTracks) {
                      totalTrackedInSeconds += itemFilteredTrack.trackedInSeconds ?? 0;
                    }
                    final filteredTracksLocal = listTrackLocal.where((e) => e.taskId == id);
                    for (final itemFilteredTrackLocal in filteredTracksLocal) {
                      totalTrackedInSeconds += itemFilteredTrackLocal.duration;
                    }
                    listTrackTask[index].trackedInSeconds = totalTrackedInSeconds;
                  }
                }
              },
            ),
            BlocListener<TrackingBloc, TrackingState>(
              listener: (context, state) {
                if (state is FailureTrackingState) {
                  /* Nothing to do in here */
                } else if (state is SuccessCreateTimeTrackingState) {
                  final files = state.files;
                  for (final path in files) {
                    final file = File(path);
                    if (file.existsSync()) {
                      file.deleteSync();
                    }
                  }
                  final trackEntityId = state.trackEntityId;
                  trackDao.deleteTrackById(trackEntityId);
                } else if (state is SuccessCronTrackingState) {
                  // TODO: tampilkan info last sync at: 22:09 04 Jul 2023
                  // TODO: info ini akan ditampilkan dibagian paling bawah sama seperti tampilan hubstaff
                  final ids = state.ids;
                  final files = state.files;
                  trackDao.deleteMultipleTrackByIds(ids).then((value) {
                    for (final itemFile in files) {
                      final file = File(itemFile);
                      if (file.existsSync()) {
                        file.deleteSync();
                      }
                    }
                  });
                }
              },
            ),
            BlocListener<UserProfileBloc, UserProfileState>(
              listener: (context, state) {
                if (state is SuccessLoadDataUserProfileState) {
                  final response = state.response;
                  final name = response.name ?? '';
                  final userRole = response.role;
                  sharedPreferencesManager.putString(
                    SharedPreferencesManager.keyFullName,
                    name,
                  );
                  sharedPreferencesManager.putString(
                    SharedPreferencesManager.keyUserRole,
                    userRole?.name ?? '',
                  );
                }
              },
            ),
          ],
          child: SizedBox(
            width: double.infinity,
            child: buildWidgetBody(),
          ),
        ),
      ),
    );
  }

  Widget buildWidgetBody() {
    return Column(
      children: [
        buildWidgetHeader(),
        Expanded(
          child: buildWidgetContent(),
        ),
      ],
    );
  }

  Widget buildWidgetContent() {
    return Padding(
      padding: EdgeInsets.all(helper.getDefaultPaddingLayout),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildWidgetFieldProject(),
          const SizedBox(height: 24),
          buildWidgetTimer(),
          const SizedBox(height: 24),
          Expanded(
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is LoadingHomeState) {
                  return const WidgetCustomCircularProgressIndicator();
                } else if (state is FailureHomeState) {
                  final errorMessage = state.errorMessage;
                  return WidgetError(
                    title: 'oops'.tr(),
                    message: errorMessage,
                    onTryAgain: doLoadData,
                  );
                }
                return buildWidgetListTrack();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildWidgetListTrack() {
    if (trackUserLite == null) {
      return WidgetError(
        title: 'first_time_huh'.tr(),
        message: 'please_choose_a_project_2'.tr(),
      );
    }

    if (listTrackTask.isEmpty) {
      return WidgetError(
        title: 'you_dont_have_any_tasks'.tr(),
        message: 'create_task_to_start_working'.tr(),
      );
    }

    final formattedNow = helper.setDateFormat('EEE, dd MMM yyyy').format(infoDateTime ?? DateTime.now());

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'tasks'.plural(
                listTrackTask.length,
                args: listTrackTask.isEmpty
                    ? []
                    : [
                        listTrackTask.length.toString(),
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
              itemBuilder: (context, index) {
                final itemTask = listTrackTask[index];
                final strTrackingTime = helper.convertTrackingTimeToString(itemTask.trackedInSeconds);
                final isStart = itemTask.id == selectedTask?.id;
                final activeColor = Theme.of(context).colorScheme.primary;

                return InkWell(
                  onTap: () async {
                    if (selectedTask != itemTask) {
                      if (selectedTask != null) {
                        selectedTask!.trackedInSeconds = valueNotifierTotalTracked.value;
                        finishTime = DateTime.now();
                        await doTakeScreenshot();
                      }
                      startTime = DateTime.now();
                      selectedTask = itemTask;
                      isTimerStart = true;
                      valueNotifierTaskTracked.value = itemTask.trackedInSeconds;
                      resetCountTimer();
                      startTimer();
                    } else {
                      isTimerStart = false;
                      itemTask.trackedInSeconds = valueNotifierTaskTracked.value;
                      finishTime = DateTime.now();
                      stopTimer();
                      await doTakeScreenshot();
                      selectedTask = null;
                    }
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            itemTask.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: isStart ? activeColor : null,
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
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemCount: listTrackTask.length,
            ),
          ),
        ),
      ],
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
                final selectedProjectTemp = await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  enableDrag: false,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  builder: (context) {
                    return WidgetChooseProject(
                      defaultSelectedProjectId: selectedProject?.id,
                    );
                  },
                ) as ItemProjectResponse?;
                if (selectedProjectTemp != null) {
                  selectedProject = selectedProjectTemp;
                  final selectedProjectId = selectedProject?.id;
                  final selectedProjectName = selectedProject?.name;
                  if (selectedProjectId != null && selectedProjectName != null) {
                    await sharedPreferencesManager.putInt(
                      SharedPreferencesManager.keySelectedProjectId,
                      selectedProjectId,
                    );
                    await sharedPreferencesManager.putString(
                      SharedPreferencesManager.keySelectedProjectName,
                      selectedProjectName,
                    );
                  }
                  valueNotifierTotalTracked.value = 0;
                  final now = DateTime.now();
                  infoDateTime = DateTime(
                    now.year,
                    now.month,
                    now.day,
                  );
                  setState(() {});
                  doLoadData();
                }
              },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).colorScheme.secondary),
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
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    return Text(
                      trackUserLite?.projectName ?? 'choose_project'.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
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

  Widget buildWidgetHeader() {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      padding: const EdgeInsets.only(
        left: 16,
        top: 8,
        right: 16,
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
                context.pushNamed(EditProfilePage.routeName);
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.solidCircleUser,
                      color: Theme.of(context).colorScheme.primaryContainer,
                      size: 14,
                    ),
                    const SizedBox(width: 8),
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
                context.pushNamed(SyncPage.routeName);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 8,
                ),
                child: Icon(
                  Icons.sync,
                  size: 16,
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () {
                context.pushNamed(ReportScreenshotPage.routeName);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 8,
                ),
                child: Icon(
                  Icons.bar_chart_outlined,
                  size: 16,
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () {
                context.pushNamed(SettingPage.routeName);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 8,
                ),
                child: Icon(
                  Icons.settings,
                  size: 16,
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> doLoadData() async {
    listTrackTask.clear();
    final now = DateTime.now();
    final formattedNow = helper.setDateFormat('yyyy-MM-dd').format(now);
    final selectedProjectId = selectedProject?.id;
    if (selectedProjectId == null) {
      return;
    }

    listTrackLocal.clear();
    final newListTrackLocal = await trackDao.findAllTrackLikeDate('$formattedNow%');
    listTrackLocal.addAll(newListTrackLocal);

    homeBloc.add(
      LoadDataHomeEvent(
        date: formattedNow,
        projectId: selectedProjectId.toString(),
      ),
    );
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
            color: Theme.of(context).colorScheme.primaryContainer,
            fontWeight: FontWeight.bold,
          ),
    );
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

  Future<void> doTakeScreenshot() async {
    var percentActivity = 0.0;
    if (counterActivity > 0 && countTimerInSeconds > 0) {
      percentActivity = (counterActivity / countTimerInSeconds) * 100;
    }
    counterActivity = 0;

    if (selectedProject == null || selectedTask == null) {
      return;
    }

    final taskId = selectedTask?.id;

    if (startTime == null || finishTime == null) {
      return;
    }

    final startDateTime = DateTime(
      startTime!.year,
      startTime!.month,
      startTime!.day,
      startTime!.hour,
      startTime!.minute,
      startTime!.second,
    );
    final finishDateTime = DateTime(
      finishTime!.year,
      finishTime!.month,
      finishTime!.day,
      finishTime!.hour,
      finishTime!.minute,
      finishTime!.second,
    );
    final timezoneOffsetInSeconds = startTime!.timeZoneOffset.inSeconds;
    final timezoneOffset = helper.convertSecondToHms(timezoneOffsetInSeconds);
    var strTimezoneOffset = timezoneOffsetInSeconds >= 0 ? '+' : '-';
    strTimezoneOffset += timezoneOffset.hour < 10 ? '0${timezoneOffset.hour}' : timezoneOffset.hour.toString();
    strTimezoneOffset += ':';
    strTimezoneOffset += timezoneOffset.minute < 10 ? '0${timezoneOffset.minute}' : timezoneOffset.minute.toString();

    const datePattern = 'yyyy-MM-dd';
    const timePattern = 'HH:mm:ss';

    final strStartDate = helper.setDateFormat(datePattern).format(startDateTime);
    final strStartTime = helper.setDateFormat(timePattern).format(startDateTime);
    final formattedStartDateTime = '${strStartDate}T$strStartTime$strTimezoneOffset';

    final strFinishDate = helper.setDateFormat(datePattern).format(finishDateTime);
    final strFinishTime = helper.setDateFormat(timePattern).format(finishDateTime);
    final formattedFinishDateTime = '${strFinishDate}T$strFinishTime$strTimezoneOffset';

    final durationInSeconds = finishDateTime.difference(startDateTime).inSeconds.abs();

    final activity = percentActivity.round();

    final listPathScreenshots = await platformChannelHelper.doTakeScreenshot();
    if (listPathScreenshots.isEmpty) {
      debugPrint('list path screenshots is empty');
      valueNotifierTotalTracked.value -= durationInSeconds;
      valueNotifierTaskTracked.value -= durationInSeconds;
      isTimerStart = false;
      stopTimer();
      selectedTask = null;
      setState(() {});
      return;
    }
    listPathScreenshots.removeWhere((element) => element == null || element.isEmpty);
    if (listPathScreenshots.isNotEmpty) {
      final firstElement = listPathScreenshots.first ?? '';
      final splitBySlash = firstElement.split('/');
      var baseFilePath = '';
      if (splitBySlash.isNotEmpty) {
        for (var index = 0; index < splitBySlash.length - 1; index++) {
          final element = splitBySlash[index];
          baseFilePath += '/$element';
        }
      }
      if (baseFilePath.isNotEmpty) {
        await sharedPreferencesManager.putString(
          SharedPreferencesManager.keyBaseFilePathScreenshot,
          baseFilePath,
        );
      }
    }
    final files = listPathScreenshots.join(',');

    final isShowScreenshotNotification =
        sharedPreferencesManager.getBool(SharedPreferencesManager.keyIsEnableScreenshotNotification) ?? false;
    if (isShowScreenshotNotification) {
      notificationHelper.showScreenshotTakenNotification();
    }

    final trackEntity = Track(
      userId: userId,
      taskId: taskId!,
      startDate: formattedStartDateTime,
      finishDate: formattedFinishDateTime,
      activity: activity,
      files: files,
      duration: durationInSeconds,
      projectName: selectedProject?.name ?? '',
      taskName: selectedTask?.name ?? '',
    );
    final trackEntityId = await trackDao.insertTrack(trackEntity);

    trackingBloc.add(
      CreateTimeTrackingEvent(
        body: CreateTrackBody(
          userId: userId,
          taskId: taskId,
          startDate: formattedStartDateTime,
          finishDate: formattedFinishDateTime,
          activity: activity,
          duration: durationInSeconds,
          files: files.split(','),
        ),
        trackEntityId: trackEntityId,
      ),
    );
  }

  void resetCountTimer() {
    countTimerInSeconds = 0;
  }

  void startTimer() {
    stopTimer();
    timeTrack = Timer.periodic(const Duration(seconds: 1), (_) {
      increaseTimerTray();
    });
  }

  void stopTimer() {
    if (timeTrack != null && timeTrack!.isActive) {
      timeTrack!.cancel();
    }
  }

  Future<void> increaseTimerTray() async {
    if (isHaveActivity) {
      counterActivity += 1;
    }
    isHaveActivity = false;
    valueNotifierTotalTracked.value += 1;
    countTimerInSeconds += 1;
    if (selectedTask != null) {
      valueNotifierTaskTracked.value += 1;
    }
    if (countTimerInSeconds >= intervalScreenshot) {
      finishTime = DateTime.now();
      await doTakeScreenshot();
      resetCountTimer();
      startTime = DateTime.now();
      finishTime = null;
    }
    final strTrackingTimeTemp = helper.convertTrackingTimeToString(valueNotifierTotalTracked.value);
    setTrayTitle(title: strTrackingTimeTemp);
  }

  Widget buildWidgetTimer() {
    return ValueListenableBuilder(
      valueListenable: valueNotifierTotalTracked,
      builder: (BuildContext context, int value, _) {
        final strTotalTrackingTime = helper.convertTrackingTimeToString(value);
        return Text(
          strTotalTrackingTime,
          style: Theme.of(context).textTheme.displayMedium,
          textAlign: TextAlign.center,
        );
      },
    );
  }

  void checkAssetAudio() async {
    // Copy file audio dari aset ke /Library/Sounds [macOS]
    final bytes = await rootBundle.load('assets/audio/hasta_la_vista.aiff');
    final libraryDirectory = await getLibraryDirectory();
    final directory = Directory('${libraryDirectory.path}/sounds');
    final pathDirectory = directory.path;
    final buffer = bytes.buffer;
    final fileAudioReminderNotTrack = File('$pathDirectory/hasta_la_vista.aiff');
    if (!fileAudioReminderNotTrack.existsSync()) {
      fileAudioReminderNotTrack.writeAsBytes(
        buffer.asUint8List(
          bytes.offsetInBytes,
          buffer.lengthInBytes,
        ),
      );
    }
  }
}
