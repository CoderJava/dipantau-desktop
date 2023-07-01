import 'dart:io';

import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/core/util/images.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/core/util/widget_helper.dart';
import 'package:dipantau_desktop_client/feature/database/dao/track/track_dao.dart';
import 'package:dipantau_desktop_client/feature/database/entity/track/track.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/photo_view/photo_view_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_error.dart';
import 'package:dipantau_desktop_client/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class SyncPage extends StatefulWidget {
  static const routePath = '/sync';
  static const routeName = 'sync';

  const SyncPage({Key? key}) : super(key: key);

  @override
  State<SyncPage> createState() => _SyncPageState();
}

class _SyncPageState extends State<SyncPage> {
  final trackDao = sl<TrackDao>();
  final listTracks = <Track>[];
  final sharedPreferencesManager = sl<SharedPreferencesManager>();
  final helper = sl<Helper>();
  final widgetHelper = WidgetHelper();

  var userId = '';
  var isLoaded = false;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    userId = sharedPreferencesManager.getString(SharedPreferencesManager.keyUserId) ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      listTracks.addAll(await trackDao.findAllTrack(userId));
      isLoaded = true;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('track_not_sync'.tr()),
        centerTitle: false,
      ),
      body: buildWidgetBody(),
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
          message: 'no_data_to_display'.tr(),
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
        const heightImage = 128.0;

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
