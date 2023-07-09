import 'dart:io';

import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/core/util/images.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/core/util/string_extension.dart';
import 'package:dipantau_desktop_client/core/util/widget_helper.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/bulk_create_track_data_body.dart';
import 'package:dipantau_desktop_client/feature/database/dao/track/track_dao.dart';
import 'package:dipantau_desktop_client/feature/database/entity/track/track.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/tracking/tracking_bloc.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/photo_view/photo_view_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_error.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_primary_button.dart';
import 'package:dipantau_desktop_client/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SyncPage extends StatefulWidget {
  static const routePath = '/sync';
  static const routeName = 'sync';

  const SyncPage({Key? key}) : super(key: key);

  @override
  State<SyncPage> createState() => _SyncPageState();
}

class _SyncPageState extends State<SyncPage> {
  final trackingBloc = sl<TrackingBloc>();
  final trackDao = sl<TrackDao>();
  final listTracks = <Track>[];
  final sharedPreferencesManager = sl<SharedPreferencesManager>();
  final helper = sl<Helper>();
  final widgetHelper = WidgetHelper();

  var userId = '';
  var isLoaded = false;
  var widthScreen = 0.0;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    userId = sharedPreferencesManager.getString(SharedPreferencesManager.keyUserId) ?? '';
    doLoadData();
    super.initState();
  }

  Future<void> doLoadData() async {
    listTracks.clear();
    listTracks.addAll(await trackDao.findAllTrack(userId));
    isLoaded = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    widthScreen = mediaQueryData.size.width;
    return BlocProvider<TrackingBloc>(
      create: (context) => trackingBloc,
      child: BlocListener<TrackingBloc, TrackingState>(
        listener: (context, state) {
          if (state is! LoadingTrackingState) {
            // untuk menutup dialog loading
            Navigator.pop(context);
          }

          if (state is FailureTrackingState) {
            final errorMessage = state.errorMessage.convertErrorMessageToHumanMessage();
            if (errorMessage.contains('401')) {
              widgetHelper.showDialog401(context);
              return;
            }
            widgetHelper.showSnackBar(context, errorMessage.hideResponseCode());
          } else if (state is SuccessSyncManualTrackingState) {
            final ids = listTracks.where((element) => element.id != null).map((e) => e.id!).toList();
            trackDao.deleteMultipleTrackByIds(ids).then((_) => doLoadData());
            showDialogSuccessfully();
          } else if (state is LoadingTrackingState) {
            showDialogLoading();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('track_not_sync'.tr()),
            centerTitle: false,
            actions: [
              listTracks.isEmpty
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: WidgetPrimaryButton(
                        onPressed: () {
                          final body = BulkCreateTrackDataBody(
                            data: listTracks.map((e) {
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
                            }).toList(),
                          );
                          trackingBloc.add(
                            SyncManualTrackingEvent(
                              body: body,
                            ),
                          );
                        },
                        child: Text(
                          'sync_now'.tr(),
                        ),
                      ),
                    ),
            ],
          ),
          body: buildWidgetBody(),
        ),
      ),
    );
  }

  void showDialogLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: LottieBuilder.asset(
            BaseAnimation.animationUpload,
            repeat: false,
            width: 92,
            height: 92,
          ),
          content: Text(
            'uploading_data'.tr(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
      },
    );
  }

  void showDialogSuccessfully() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: LottieBuilder.asset(
            BaseAnimation.animationSuccess,
            repeat: false,
            width: 64,
            height: 64,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'uploading_data_successfully'.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'note'.tr(),
                    ),
                    TextSpan(
                      text: ' ${'screenshot_data_sync_background'.tr()}',
                    ),
                  ],
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildWidgetBody() {
    if (!isLoaded) {
      return Container();
    }

    if (listTracks.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(helper.getDefaultPaddingLayout),
        child: WidgetError(
          title: 'info'.tr(),
          message: 'your_data_is_already_synced'.tr(),
        ),
      );
    }

    return AlignedGridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.only(
        left: helper.getDefaultPaddingLayout,
        top: helper.getDefaultPaddingLayoutTop,
        right: helper.getDefaultPaddingLayout,
        bottom: helper.getDefaultPaddingLayout,
      ),
      mainAxisSpacing: helper.getDefaultPaddingLayout,
      crossAxisSpacing: helper.getDefaultPaddingLayout,
      itemCount: listTracks.length,
      itemBuilder: (context, index) {
        final element = listTracks[index];
        final projectName = element.projectName;
        final taskName = element.taskName;
        final strStartDate = element.startDate;
        final strFinishDate = element.finishDate;
        var strStartDateWithoutTimezone = '';
        var strFinishDateWithoutTimezone = '';
        if (strStartDate.length >= 25) {
          // 2023-06-30T07:28:21+07:00 ini akan dipotong menjadi 2023-06-30T07:28:21
          strStartDateWithoutTimezone = strStartDate.substring(0, 19);
        }
        if (strFinishDate.length >= 25) {
          // 2023-06-30T07:28:21+07:00 ini akan dipotong menjadi 2023-06-30T07:28:21
          strFinishDateWithoutTimezone = strFinishDate.substring(0, 19);
        }
        final startDate = DateTime.tryParse(strStartDateWithoutTimezone);
        final finishDate = DateTime.tryParse(strFinishDateWithoutTimezone);
        final durationInSeconds = element.duration;
        final activity = element.activity;

        final strFiles = element.files;
        File? thumbnail;
        final listFiles = <String>[];
        final listScreenshots = <File>[];
        if (strFiles.contains(',')) {
          listFiles.addAll(strFiles.split(','));
        } else {
          listFiles.add(strFiles);
        }
        if (listFiles.isNotEmpty) {
          for (final file in listFiles) {
            final screenshot = File(file);
            if (screenshot.existsSync()) {
              listScreenshots.add(screenshot);
            }
          }
        }
        if (listScreenshots.isNotEmpty) {
          thumbnail = listScreenshots.first;
        }
        const heightImage = 92.0;

        return Column(
          children: [
            buildWidgetProjectName(projectName),
            const SizedBox(height: 4),
            buildWidgetTaskName(taskName),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              padding: const EdgeInsets.only(bottom: 16),
              child: Stack(
                children: [
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                        child: Image.file(
                          thumbnail ?? File(''),
                          width: double.infinity,
                          height: heightImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stacktrace) {
                            return Image.asset(
                              BaseImage.imagePlaceholder,
                              width: double.infinity,
                              height: heightImage,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      buildWidgetTime(startDate, finishDate),
                      const SizedBox(height: 8),
                      buildWidgetActivity(activity, durationInSeconds),
                    ],
                  ),
                  Material(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    color: Theme.of(context).colorScheme.inverseSurface.withOpacity(0),
                    child: InkWell(
                      hoverColor: Theme.of(context).colorScheme.inverseSurface.withOpacity(.2),
                      onTap: () {
                        context.pushNamed(
                          PhotoViewPage.routeName,
                          extra: {
                            PhotoViewPage.parameterListPhotos: listScreenshots.map((e) => e.path).toList(),
                          },
                        );
                      },
                      child: Container(
                        height: heightImage,
                      ),
                    ),
                  ),
                  buildWidgetCountScreen(heightImage, listFiles),
                  buildWidgetIconDelete(element.id, heightImage),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildWidgetCountScreen(double heightImage, List<String> listFiles) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: Theme.of(context).colorScheme.onInverseSurface,
          border: Border.all(color: Colors.grey, width: 0.3),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onBackground.withOpacity(.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 10,
        ),
        margin: EdgeInsets.only(top: heightImage - 12),
        child: Text(
          'screen_n'.plural(listFiles.length),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      ),
    );
  }

  Widget buildWidgetTaskName(String taskName) {
    return Text(
      taskName,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget buildWidgetProjectName(String projectName) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.grey,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 2,
      ),
      child: Text(
        projectName,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onInverseSurface,
            ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  buildWidgetTime(DateTime? startDate, DateTime? finishDate) {
    if (startDate == null || finishDate == null) {
      return Text('invalid_time'.tr());
    }

    // beberapa contoh untuk tampilan waktunya
    // Sat 01 Jul 2023, 08:00:00 - 08:05:00 (untuk saat ini pakai yang mode ini)
    // Sat 01 Jul 2023, 23:58:00 - Sun 02 Jul 2023, 00:03:00
    // Fri 30 Jun 2023, 23:58:00 - Sat 01 Jul 2023, 00:03:00
    // Sun 31 Dec 2023, 23:58:00 - Mon 01 Jan 2024, 00:03:00
    var strTime = '-';
    final formattedDate = helper.setDateFormat('dd MMM yyyy').format(startDate);
    final strStartTime = helper.setDateFormat('HH:mm:ss').format(startDate);
    final strFinishTime = helper.setDateFormat('HH:mm:ss').format(finishDate);
    strTime = '$formattedDate\n$strStartTime - $strFinishTime';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        strTime,
        style: Theme.of(context).textTheme.bodyMedium,
        maxLines: 2,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildWidgetActivity(int activity, int durationInSeconds) {
    final duration = helper.convertSecondToHms(durationInSeconds);
    final durationMinute = duration.minute;
    final durationSecond = duration.second;
    final listStrDuration = <String>[];
    if (durationMinute > 0) {
      listStrDuration.add('alias_minute_n'.tr(args: [durationMinute.toString()]));
    }
    if (durationSecond > 0) {
      listStrDuration.add('alias_second_n'.tr(args: [durationSecond.toString()]));
    }
    var strDuration = '';
    if (listStrDuration.isEmpty) {
      strDuration = 'minute_n'.plural(0);
    } else {
      strDuration = listStrDuration.join(' ');
    }
    var strActivity = 'activity_percent'.tr(
      args: [
        activity.toString(),
        strDuration,
      ],
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: activity / 100,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            strActivity,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget buildWidgetIconDelete(int? id, double heightImage) {
    return Positioned(
      right: -4,
      top: heightImage - 4,
      child: IconButton(
        onPressed: () {
          if (id == null) {
            widgetHelper.showSnackBar(context, 'invalid_id_track'.tr());
          }

          showDialog<bool?>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('title_delete_track'.tr()),
                content: Text('content_delete_track'.tr()),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text('cancel'.tr()),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: Text('delete'.tr()),
                  ),
                ],
              );
            },
          ).then((value) async {
            if (value != null && value) {
              await trackDao.deleteTrackById(id!);
              listTracks.removeWhere((element) => element.id != null && element.id == id);
              setState(() {});
              if (mounted) {
                widgetHelper.showSnackBar(context, 'track_data_deleted_successfully'.tr());
              }
            }
          });
        },
        icon: const FaIcon(
          FontAwesomeIcons.trashCan,
          size: 14,
          color: Colors.red,
        ),
      ),
    );
  }
}
