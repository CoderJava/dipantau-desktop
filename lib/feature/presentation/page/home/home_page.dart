import 'dart:async';
import 'dart:io';

import 'package:dipantau_desktop_client/core/network/network_info.dart';
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
import 'package:dipantau_desktop_client/feature/domain/usecase/user_version/user_version_body.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/cron_tracking/cron_tracking_bloc.dart';
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

var countTimeReminderTrackInSeconds = 0;

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
  final cronTrackingBloc = sl<CronTrackingBloc>();
  final helper = sl<Helper>();
  final listTrackTask = <TrackTask>[];
  final widgetHelper = WidgetHelper();
  final keyTrayShowTimer = 'tray-show-timer';
  final keyTrayHideTimer = 'tray-hide-timer';
  final keyTrayStartWorking = 'tray-start-working';
  final keyTrayStopWorking = 'tray-stop-working';
  final keyTrayQuitApp = 'tray-quit-app';
  final platformChannelHelper = PlatformChannelHelper();
  final valueNotifierTotalTracked = ValueNotifier<int>(0);
  final valueNotifierTaskTracked = ValueNotifier<int>(0);
  final flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();
  final notificationHelper = sl<NotificationHelper>();
  final intervalScreenshot = 60 * 5; // 300 detik (5 menit)
  final listTrackLocal = <Track>[];
  final listPathStartScreenshots = <String?>[];
  final networkInfo = sl<NetworkInfo>();

  var isWindowVisible = true;
  var userId = '';
  var email = '';
  var isTimerStart = false;
  var isTimerStartTemp = false;
  TrackUserLiteResponse? trackUserLite;
  ItemProjectResponse? selectedProject;
  TrackTask? selectedTask;
  Timer? timeTrack, timerCronTrack, timerDate;
  var countTimerInSeconds = 0;
  var isHaveActivity = false;
  var counterActivity = 0;
  DateTime? startTime;
  DateTime? finishTime;
  DateTime? infoDateTime;
  DateTime? now;
  var isLoading = false;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    sharedPreferencesManager.putBool(SharedPreferencesManager.keyIsAutoStartTask, false);
    startTimerDate();
    doLoadDataUserProfile();
    userId = sharedPreferencesManager.getString(SharedPreferencesManager.keyUserId) ?? '';
    email = sharedPreferencesManager.getString(SharedPreferencesManager.keyEmail) ?? '';
    if (!sharedPreferencesManager.isKeyExists(SharedPreferencesManager.keyIsEnableScreenshotNotification)) {
      sharedPreferencesManager.putBool(SharedPreferencesManager.keyIsEnableScreenshotNotification, true);
    }
    if (!sharedPreferencesManager.isKeyExists(SharedPreferencesManager.keyIsEnableSoundScreenshotNotification)) {
      sharedPreferencesManager.putBool(SharedPreferencesManager.keyIsEnableSoundScreenshotNotification, true);
    }
    initDefaultSelectedProject();
    setupWindow();
    setupTray();
    doStartEventListener();
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
      doLoadDataTask();
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
      if (!isTimerStart) {
        // reminder track
        var isShowReminderTrack = false;
        final now = DateTime.now();
        countTimeReminderTrackInSeconds += 1;
        final isEnableReminderTrack =
            sharedPreferencesManager.getBool(SharedPreferencesManager.keyIsEnableReminderTrack) ?? false;
        if (isEnableReminderTrack) {
          DateTime? startReminderTrack, finishReminderTrack;
          final strStartReminderTrack = sharedPreferencesManager.getString(
                SharedPreferencesManager.keyStartTimeReminderTrack,
              ) ??
              '';
          if (strStartReminderTrack.contains(':') && strStartReminderTrack.split(':').length == 2) {
            final splitStrStartReminderTrack = strStartReminderTrack.split(':');
            final strStartHourReminderTrack = splitStrStartReminderTrack.first;
            final strStartMinuteReminderTrack = splitStrStartReminderTrack.last;
            final startHourReminderTrack = int.tryParse(strStartHourReminderTrack);
            final startMinuteReminderTrack = int.tryParse(strStartMinuteReminderTrack);
            if (startHourReminderTrack != null && startMinuteReminderTrack != null) {
              startReminderTrack = DateTime(
                now.year,
                now.month,
                now.day,
                startHourReminderTrack,
                startMinuteReminderTrack,
              );
            }
          }

          final strFinishReminderTrack = sharedPreferencesManager.getString(
                SharedPreferencesManager.keyFinishTimeReminderTrack,
              ) ??
              '';
          if (strFinishReminderTrack.contains(':') && strFinishReminderTrack.split(':').length == 2) {
            final splitStrFinishReminderTrack = strFinishReminderTrack.split(':');
            final strFinishHourReminderTrack = splitStrFinishReminderTrack.first;
            final strFinishMinuteReminderTrack = splitStrFinishReminderTrack.last;
            final finishHourReminderTrack = int.tryParse(strFinishHourReminderTrack);
            final finishMinuteReminderTrack = int.tryParse(strFinishMinuteReminderTrack);
            if (finishHourReminderTrack != null && finishMinuteReminderTrack != null) {
              finishReminderTrack = DateTime(
                now.year,
                now.month,
                now.day,
                finishHourReminderTrack,
                finishMinuteReminderTrack,
              );
            }
          }

          final daysReminderTrack =
              sharedPreferencesManager.getStringList(SharedPreferencesManager.keyDayReminderTrack) ?? [];
          final nowWeekday = now.weekday;
          final isTodayReminderTrackEnabled =
              daysReminderTrack.where((element) => element == nowWeekday.toString()).isNotEmpty;

          int? intervalReminderTrackInSeconds;
          final intervalReminderTrackInMinutes =
              sharedPreferencesManager.getInt(SharedPreferencesManager.keyIntervalReminderTrack) ?? -1;
          if (intervalReminderTrackInMinutes != -1 && intervalReminderTrackInMinutes > 0) {
            intervalReminderTrackInSeconds = intervalReminderTrackInMinutes * 60;
          }

          if (startReminderTrack != null &&
              finishReminderTrack != null &&
              isTodayReminderTrackEnabled &&
              countTimeReminderTrackInSeconds == intervalReminderTrackInSeconds) {
            if (now.isAfter(startReminderTrack) && now.isBefore(finishReminderTrack) ||
                (now.isAtSameMomentAs(startReminderTrack) || now.isAtSameMomentAs(finishReminderTrack))) {
              isShowReminderTrack = true;
            }
          }

          if (countTimeReminderTrackInSeconds == intervalReminderTrackInSeconds ||
              intervalReminderTrackInSeconds == null) {
            countTimeReminderTrackInSeconds = 0;
          }

          if (isShowReminderTrack) {
            notificationHelper.showReminderNotTrackNotification();
          }
        } else {
          countTimeReminderTrackInSeconds = 0;
        }
      }

      // reset timer jika berpindah hari
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
        final strTrackingTimeTemp = helper.convertTrackingTimeToString(valueNotifierTotalTracked.value);
        setTrayTitle(title: strTrackingTimeTemp);
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
        cronTrackingBloc.add(
          RunCronTrackingEvent(
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
          ),
          BlocProvider<CronTrackingBloc>(
            create: (context) => cronTrackingBloc,
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<HomeBloc, HomeState>(
              listener: (context, state) async {
                isLoading = state is LoadingHomeState;
                if (state is FailureHomeState) {
                  final errorMessage = state.errorMessage;
                  if (errorMessage.contains('401')) {
                    widgetHelper.showDialog401(context);
                    return;
                  }
                } else if (state is SuccessLoadDataHomeState) {
                  isTimerStartTemp = false;
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
                  setTrayContextMenu();

                  final isAutoStart = state.isAutoStart;
                  if (isAutoStart) {
                    autoStartFromSleep();
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
            BlocListener<CronTrackingBloc, CronTrackingState>(
              listener: (context, state) {
                if (state is SuccessRunCronTrackingState) {
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
          ],
          child: SizedBox(
            width: double.infinity,
            child: buildWidgetBody(),
          ),
        ),
      ),
    );
  }

  Future<void> autoStartFromSleep() async {
    final selectedTaskName = sharedPreferencesManager.getString(SharedPreferencesManager.keySelectedTaskName) ?? '';
    final selectedTaskId = sharedPreferencesManager.getInt(SharedPreferencesManager.keySelectedTaskId) ?? -1;
    if (selectedTaskName.isNotEmpty && selectedTaskId != -1) {
      final filteredTask = listTrackTask.where((element) {
        return element.id == selectedTaskId && element.name == selectedTaskName;
      });
      if (filteredTask.isNotEmpty) {
        final firstTask = filteredTask.first;
        startTime = DateTime.now();
        selectedTask = firstTask;
        isTimerStart = true;
        setTrayContextMenu();
        valueNotifierTaskTracked.value = firstTask.trackedInSeconds;
        resetCountTimer();
        startTimer();
        setState(() {});
      }
    }
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
                if (state is LoadingHomeState || isLoading) {
                  return const WidgetCustomCircularProgressIndicator();
                } else if (state is FailureHomeState) {
                  final errorMessage = state.errorMessage;
                  return WidgetError(
                    title: 'oops'.tr(),
                    message: errorMessage,
                    onTryAgain: doLoadDataTask,
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
                    final isPermissionScreenRecordingGranted =
                        await platformChannelHelper.checkPermissionScreenRecording();
                    if (mounted && isPermissionScreenRecordingGranted != null && !isPermissionScreenRecordingGranted) {
                      widgetHelper.showDialogPermissionScreenRecording(context);
                      return;
                    }

                    if (isPermissionScreenRecordingGranted!) {
                      final isPermissionAccessibilityGranted =
                          await platformChannelHelper.checkPermissionAccessibility();
                      if (mounted && isPermissionAccessibilityGranted != null && !isPermissionAccessibilityGranted) {
                        widgetHelper.showDialogPermissionAccessibility(context);
                        return;
                      }
                    }

                    if (selectedTask?.id != itemTask.id) {
                      if (selectedTask != null) {
                        selectedTask!.trackedInSeconds = valueNotifierTaskTracked.value;
                        finishTime = DateTime.now();
                        doTakeScreenshot(startTime, finishTime);
                      }
                      startTime = DateTime.now();
                      selectedTask = itemTask;
                      isTimerStart = true;
                      setTrayContextMenu();
                      valueNotifierTaskTracked.value = itemTask.trackedInSeconds;
                      resetCountTimer();
                      startTimer();
                    } else {
                      stopTimerFromButton(itemTask);
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

  void stopTimerFromButton(TrackTask itemTask) {
    isTimerStart = false;
    setTrayContextMenu();
    itemTask.trackedInSeconds = valueNotifierTaskTracked.value;
    stopTimer();
    finishTime = DateTime.now();
    doTakeScreenshot(startTime, finishTime);
    selectedTask = null;
  }

  Widget buildWidgetFieldProject() {
    return Material(
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: isTimerStart || isTimerStartTemp
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
                  doLoadDataTask();
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
                  color: isTimerStart || isTimerStartTemp ? Colors.green : Colors.grey,
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
              isTimerStart || isTimerStartTemp
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
                context.pushNamed<bool?>(ReportScreenshotPage.routeName).then((value) async {
                  if (value != null && value) {
                    setState(() => isLoading = true);
                    isTimerStartTemp = isTimerStart;
                    stopTimerFromSystemTray();
                    doLoadDataTask(isAutoStart: isTimerStartTemp);
                  }
                });
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

  Future<void> doLoadDataTask({bool isAutoStart = false}) async {
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

    UserVersionBody? userVersionBody;
    final versionCode = packageInfo.buildNumber;
    final versionName = packageInfo.version;
    final strUserId = sharedPreferencesManager.getString(SharedPreferencesManager.keyUserId) ?? '';
    final userId = int.tryParse(strUserId);
    if (strUserId.isNotEmpty && userId != null) {
      userVersionBody = UserVersionBody(
        code: versionCode,
        name: versionName,
        userId: userId,
      );
    }

    homeBloc.add(
      LoadDataHomeEvent(
        date: formattedNow,
        projectId: selectedProjectId.toString(),
        isAutoStart: isAutoStart,
        userVersionBody: userVersionBody,
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
    if (listTrackTask.isNotEmpty) {
      if (!isTimerStart) {
        items.add(
          MenuItem(
            key: keyTrayStartWorking,
            label: 'start_working'.tr(),
          ),
        );
      } else {
        items.add(
          MenuItem(
            key: keyTrayStopWorking,
            label: 'stop_working'.tr(),
          ),
        );
      }
    }

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
    if (keyMenuItem == keyTrayStartWorking) {
      startTaskFromSystemTray();
    } else if (keyMenuItem == keyTrayStopWorking) {
      stopTimerFromSystemTray();
    } else if (keyMenuItem == keyTrayShowTimer) {
      windowManager.show();
      isWindowVisible = true;
    } else if (keyMenuItem == keyTrayHideTimer) {
      windowManager.hide();
      isWindowVisible = false;
    } else if (keyMenuItem == keyTrayQuitApp) {
      platformChannelHelper.doQuitApp();
    }
  }

  void startTaskFromSystemTray() {
    final lastSelectedTaskName = sharedPreferencesManager.getString(SharedPreferencesManager.keySelectedTaskName) ?? '';
    final lastSelectedTaskId = sharedPreferencesManager.getInt(SharedPreferencesManager.keySelectedTaskId) ?? -1;
    final filteredTask = listTrackTask.where((element) {
      return element.id == lastSelectedTaskId && element.name == lastSelectedTaskName;
    });
    if (filteredTask.isEmpty) {
      // start task pertama yang ada
      final task = listTrackTask.first;
      startTime = DateTime.now();
      selectedTask = task;
      isTimerStart = true;
      setTrayContextMenu();
      valueNotifierTaskTracked.value = task.trackedInSeconds;
      resetCountTimer();
      startTimer();
      setState(() {});
    } else {
      // start task terakhir kali yang dijalankan (jika ada)
      final task = filteredTask.first;
      startTime = DateTime.now();
      selectedTask = task;
      isTimerStart = true;
      setTrayContextMenu();
      valueNotifierTaskTracked.value = task.trackedInSeconds;
      resetCountTimer();
      startTimer();
      setState(() {});
    }
  }

  void stopTimerFromSystemTray() {
    isTimerStart = false;
    setTrayContextMenu();
    selectedTask?.trackedInSeconds = valueNotifierTaskTracked.value;
    stopTimer();
    finishTime = DateTime.now();
    doTakeScreenshot(startTime, finishTime);
    selectedTask = null;
    setState(() {});
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

  void doStartEventListener() {
    platformChannelHelper.setActivityListener();
    platformChannelHelper.startEventChannel().listen((Object? event) async {
      if (event != null) {
        if (event is String) {
          final strEvent = event.toLowerCase();
          if (strEvent == 'triggered') {
            // update flag activity menjadi true
            isHaveActivity = true;
          } else if (strEvent == 'screen_is_locked') {
            // auto stop timer dan ambil screenshot-nya
            if (isTimerStart) {
              isTimerStart = false;
              setTrayContextMenu();
              stopTimer();
              finishTime = DateTime.now();
              doTakeScreenshot(startTime, finishTime, isForceStop: true);
              await sharedPreferencesManager.putBool(
                SharedPreferencesManager.keyIsAutoStartTask,
                true,
              );
              await sharedPreferencesManager.putInt(
                SharedPreferencesManager.keySleepTime,
                DateTime.now().millisecondsSinceEpoch,
              );

              selectedTask = null;
              setState(() {});
            }
          } else if (strEvent == 'screen_is_unlocked') {
            // muat ulang datanya setelah user unlock screen
            // dan setelah termuat datanya timer-nya dibuat auto start
            final sleepTime = sharedPreferencesManager.getInt(SharedPreferencesManager.keySleepTime) ?? 0;
            final dateTimeSleep = DateTime.fromMillisecondsSinceEpoch(sleepTime);
            final durationSleepInMinutes = DateTime.now().difference(dateTimeSleep).inMinutes.abs();
            final isAutoStartTask = sharedPreferencesManager.getBool(
                  SharedPreferencesManager.keyIsAutoStartTask,
                ) ??
                false;
            if (durationSleepInMinutes <= 30 && isAutoStartTask) {
              await sharedPreferencesManager.putBool(
                SharedPreferencesManager.keyIsAutoStartTask,
                false,
              );
              await sharedPreferencesManager.clearKey(SharedPreferencesManager.keySleepTime);
              networkInfo.isConnected.then((isConnected) {
                if (isConnected) {
                  doLoadDataTask(isAutoStart: true);
                } else {
                  autoStartFromSleep();
                }
              });
            }
          }
        }
      }
    });
  }

  void doTakeScreenshot(DateTime? startTime, DateTime? finishTime, {bool isForceStop = false}) async {
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
      startTime.year,
      startTime.month,
      startTime.day,
      startTime.hour,
      startTime.minute,
      startTime.second,
    );
    final finishDateTime = DateTime(
      finishTime.year,
      finishTime.month,
      finishTime.day,
      finishTime.hour,
      finishTime.minute,
      finishTime.second,
    );
    final timezoneOffsetInSeconds = startTime.timeZoneOffset.inSeconds;
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
    final listPathScreenshots = <String?>[];
    String files;
    if (!isForceStop) {
      listPathScreenshots.clear();
      listPathScreenshots.addAll(await platformChannelHelper.doTakeScreenshot());
      final isPermissionScreenRecordingGranted = await platformChannelHelper.checkPermissionScreenRecording();
      if ((isPermissionScreenRecordingGranted != null && !isPermissionScreenRecordingGranted) ||
          listPathScreenshots.isEmpty) {
        // stop timer-nya jika permission screen recording-nya tidak diallow-kan atau
        // gagal ambil screenshot-nya di end time
        stopTimer();
        isTimerStart = false;
        setTrayContextMenu();
        selectedTask = null;
        setState(() {});
        final fileDefaultScreenshot = await widgetHelper.getImageFileFromAssets(BaseImage.imageFileNotFound);
        listPathScreenshots.add(fileDefaultScreenshot.path);
      }
      if (listPathStartScreenshots.isNotEmpty) {
        // hapus file list path start screenshot karena tidak pakai file tersebut
        // jika file screenshot-nya dapat pas di end time
        final filtered =
            listPathStartScreenshots.where((element) => element != null && element.isNotEmpty).map((e) => e!).toList();
        for (final element in filtered) {
          final file = File(element);
          if (file.existsSync()) {
            file.deleteSync();
          }
        }
      }
    } else {
      // stop timer-nya jika isForceStop bernilai true
      listPathScreenshots.clear();
      stopTimer();
      isTimerStart = false;
      setTrayContextMenu();
      selectedTask = null;
      setState(() {});

      if (listPathStartScreenshots.isNotEmpty) {
        final listFileStartScreenshotValid = listPathStartScreenshots
            .where((element) => element != null && element.isNotEmpty && File(element).existsSync())
            .toList();
        if (listFileStartScreenshotValid.isNotEmpty) {
          // masukkan file start screenshot yang valid
          listPathScreenshots.addAll(listFileStartScreenshotValid);
        } else {
          // gunakan file default screenshot jika file start screenshot-nya tidak ada yang valid
          final fileDefaultScreenshot = await widgetHelper.getImageFileFromAssets(BaseImage.imageFileNotFound);
          listPathScreenshots.add(fileDefaultScreenshot.path);
        }
      } else {
        // gunakan file default screenshot jika file start screensho-nya empty
        final fileDefaultScreenshot = await widgetHelper.getImageFileFromAssets(BaseImage.imageFileNotFound);
        listPathScreenshots.add(fileDefaultScreenshot.path);
      }
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
    files = listPathScreenshots.join(',');

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
    final selectedTaskName = selectedTask?.name;
    final selectedTaskId = selectedTask?.id;
    sharedPreferencesManager.putString(
      SharedPreferencesManager.keySelectedTaskName,
      selectedTaskName ?? '',
    );
    sharedPreferencesManager.putInt(
      SharedPreferencesManager.keySelectedTaskId,
      selectedTaskId ?? -1,
    );
    countTimeReminderTrackInSeconds = 0;
    stopTimer();

    now = DateTime.now();
    doTakeScreenshotStart();
    timeTrack = Timer.periodic(const Duration(milliseconds: 1), (timer) {
      // intervalnya dibuat milliseconds agar bisa mengikuti dengan date time device-nya.
      final newNow = DateTime.now();
      final newNowDate = DateTime(
        newNow.year,
        newNow.month,
        newNow.day,
        newNow.hour,
        newNow.minute,
        newNow.second,
      );
      if (now != null) {
        final nowDate = DateTime(
          now!.year,
          now!.month,
          now!.day,
          now!.hour,
          now!.minute,
          now!.second,
        );
        if (!nowDate.isAtSameMomentAs(newNowDate)) {
          now = newNowDate;
          increaseTimerTray();
        }
      }
    });
  }

  void doTakeScreenshotStart() {
    platformChannelHelper.checkPermissionScreenRecording().then((isGranted) async {
      if (isGranted != null && isGranted) {
        final listPathScreenshots = await platformChannelHelper.doTakeScreenshot();
        if (listPathScreenshots.isNotEmpty) {
          listPathStartScreenshots.clear();
          listPathStartScreenshots.addAll(listPathScreenshots);
        }
      }
    });
  }

  void stopTimer() {
    countTimeReminderTrackInSeconds = 0;
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
      doTakeScreenshot(startTime, finishTime);
      resetCountTimer();
      doTakeScreenshotStart();
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
    final bytesHastaLaVista = await rootBundle.load('assets/audio/hasta_la_vista.aiff');
    final libraryDirectory = await getLibraryDirectory();
    final directory = Directory('${libraryDirectory.path}/sounds');
    final pathDirectory = directory.path;
    final bufferHastaLaVista = bytesHastaLaVista.buffer;
    final fileAudioReminderNotTrack = File('$pathDirectory/hasta_la_vista.aiff');
    if (!fileAudioReminderNotTrack.existsSync()) {
      fileAudioReminderNotTrack.writeAsBytes(
        bufferHastaLaVista.asUint8List(
          bytesHastaLaVista.offsetInBytes,
          bufferHastaLaVista.lengthInBytes,
        ),
      );
    }
  }
}
