import 'package:dipantau_desktop_client/core/util/enum/global_variable.dart';
import 'package:dipantau_desktop_client/core/util/enum/user_role.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/core/util/images.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/core/util/string_extension.dart';
import 'package:dipantau_desktop_client/core/util/widget_helper.dart';
import 'package:dipantau_desktop_client/feature/data/model/track_user/track_user_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_profile/user_profile_response.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/member/member_bloc.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/report_screenshot/report_screenshot_bloc.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/photo_view/photo_view_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_custom_circular_progress_indicator.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_error.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_primary_button.dart';
import 'package:dipantau_desktop_client/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class ReportScreenshotPage extends StatefulWidget {
  static const routePath = '/report-screenshot';
  static const routeName = 'report-screenshot';

  const ReportScreenshotPage({Key? key}) : super(key: key);

  @override
  State<ReportScreenshotPage> createState() => _ReportScreenshotPageState();
}

class _ReportScreenshotPageState extends State<ReportScreenshotPage> {
  final reportScreenshotBloc = sl<ReportScreenshotBloc>();
  final memberBloc = sl<MemberBloc>();
  final widgetHelper = WidgetHelper();
  final helper = sl<Helper>();
  final listUserProfile = <UserProfileResponse>[];
  final controllerFilterDate = TextEditingController();
  final controllerFilterUser = TextEditingController();
  final focusNode = FocusNode();

  var userId = '';
  var name = '';
  var username = '';
  UserRole? userRole;
  late DateTime selectedDate;
  UserProfileResponse? selectedUser;
  var isLoading = false;
  var isPreparingDataSuccess = false;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    setDefaultFilter();
    prepareData();
    super.initState();
  }

  void setDefaultFilter() {
    userId = sharedPreferencesManager.getString(SharedPreferencesManager.keyUserId) ?? '';
    name = sharedPreferencesManager.getString(SharedPreferencesManager.keyFullName) ?? '-';
    username = sharedPreferencesManager.getString(SharedPreferencesManager.keyEmail) ?? '-';
    final strUserRole = sharedPreferencesManager.getString(SharedPreferencesManager.keyUserRole) ?? '';
    userRole = strUserRole.fromStringUserRole;
    selectedDate = DateTime.now();
    selectedUser = UserProfileResponse(
      id: int.tryParse(userId) ?? -1,
      name: name,
      username: username,
      role: userRole,
    );
    setFormatFilterDate();
    setFilterUser();
  }

  void setFormatFilterDate() {
    controllerFilterDate.text = helper.setDateFormat('EEE, dd MMM yyyy').format(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Focus(
          focusNode: focusNode,
          child: Text(
            'report_screenshot'.tr(),
          ),
        ),
        centerTitle: false,
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<MemberBloc>(
            create: (context) => memberBloc,
          ),
          BlocProvider<ReportScreenshotBloc>(
            create: (context) => reportScreenshotBloc,
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<MemberBloc, MemberState>(
              listener: (context, state) {
                if (state is FailureMemberState) {
                  final errorMessage = state.errorMessage.convertErrorMessageToHumanMessage();
                  if (errorMessage.contains('401')) {
                    widgetHelper.showDialog401(context);
                    return;
                  }
                } else if (state is SuccessLoadListMemberState) {
                  listUserProfile.clear();
                  listUserProfile.addAll(state.response.data ?? []);
                  isPreparingDataSuccess = true;
                  setState(() {});
                }
              },
            ),
            BlocListener<ReportScreenshotBloc, ReportScreenshotState>(
              listener: (context, state) {
                isLoading = state is LoadingCenterReportScreenshotState;
                if (state is FailureReportScreenshotState) {
                  final errorMessage = state.errorMessage.convertErrorMessageToHumanMessage();
                  if (errorMessage.contains('401')) {
                    widgetHelper.showDialog401(context);
                    return;
                  }
                }
              },
            ),
          ],
          child: Stack(
            children: [
              buildWidgetBody(),
              buildWidgetLoadingPreparingData(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildWidgetBody() {
    if (!isPreparingDataSuccess) {
      return Container();
    }

    return Padding(
      padding: EdgeInsets.only(
        top: helper.getDefaultPaddingLayoutTop,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: helper.getDefaultPaddingLayout),
            child: Row(
              children: [
                Expanded(
                  child: buildWidgetFilterDate(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: buildWidgetFilterUser(),
                ),
                const SizedBox(width: 16),
                WidgetPrimaryButton(
                  onPressed: doLoadData,
                  isLoading: isLoading,
                  buttonStyle: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Text('show'.tr()),
                ),
              ],
            ),
          ),
          Expanded(
            child: buildWidgetData(),
          ),
        ],
      ),
    );
  }

  Widget buildWidgetData() {
    return BlocBuilder<ReportScreenshotBloc, ReportScreenshotState>(
      builder: (context, state) {
        if (state is LoadingCenterReportScreenshotState) {
          return const WidgetCustomCircularProgressIndicator();
        } else if (state is FailureReportScreenshotState) {
          final errorMessage = state.errorMessage;
          return WidgetError(
            title: 'oops'.tr(),
            message: errorMessage,
            onTryAgain: doLoadData,
          );
        } else if (state is SuccessLoadReportScreenshotState) {
          final listTracks = state.response.data ?? [];
          return buildWidgetListData(listTracks);
        }
        return Container();
      },
    );
  }

  void doLoadData() {
    final selectedUserId = selectedUser?.id;
    if (selectedUserId == null) {
      widgetHelper.showSnackBar(context, 'selected_user_id_invalid'.tr());
      return;
    }

    reportScreenshotBloc.add(
      LoadReportScreenshotEvent(
        userId: selectedUserId.toString(),
        date: helper.setDateFormat('yyyy-MM-dd').format(selectedDate),
      ),
    );
  }

  void prepareData() {
    memberBloc.add(LoadListMemberEvent());
  }

  Widget buildWidgetLoadingPreparingData() {
    return BlocBuilder<MemberBloc, MemberState>(
      builder: (context, state) {
        if (state is LoadingCenterMemberState) {
          return const WidgetCustomCircularProgressIndicator();
        } else if (state is FailureMemberState) {
          final errorMessage = state.errorMessage;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: helper.getDefaultPaddingLayout),
            child: WidgetError(
              title: 'oops'.tr(),
              message: errorMessage,
              onTryAgain: prepareData,
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget buildWidgetFilterDate() {
    return TextField(
      controller: controllerFilterDate,
      decoration: widgetHelper.setDefaultTextFieldDecoration(
        suffixIcon: Icon(
          Icons.calendar_month,
          color: Theme.of(context).colorScheme.inverseSurface,
        ),
      ),
      mouseCursor: MaterialStateMouseCursor.clickable,
      readOnly: true,
      style: Theme.of(context).textTheme.bodyMedium,
      onTap: () async {
        final firstDate = DateTime(
          2022,
          1,
          1,
        );
        final lastDate = DateTime.now();
        final selectedDateTemp = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: firstDate,
          lastDate: lastDate,
        );
        if (selectedDateTemp != null) {
          selectedDate = selectedDateTemp;
          setFormatFilterDate();
          setState(() {});
        }
      },
    );
  }

  Widget buildWidgetFilterUser() {
    final isEnabled = userRole != null && (userRole == UserRole.superAdmin || userRole == UserRole.admin);
    final foregroundColor = isEnabled
        ? Theme.of(context).colorScheme.inverseSurface
        : Theme.of(context).colorScheme.inverseSurface.withOpacity(.3);
    return TextField(
      controller: controllerFilterUser,
      decoration: widgetHelper.setDefaultTextFieldDecoration(
        suffixIcon: FaIcon(
          FontAwesomeIcons.userLarge,
          size: 14,
          color: foregroundColor,
        ),
        suffixIconConstraints: const BoxConstraints(
          minWidth: 28,
          maxWidth: 28,
        ),
      ),
      mouseCursor: MaterialStateMouseCursor.clickable,
      readOnly: true,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: foregroundColor,
          ),
      enabled: isEnabled,
      onTap: !isEnabled
          ? null
          : () async {
              final selectedUserTemp = await showDialog<UserProfileResponse?>(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    titlePadding: EdgeInsets.zero,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    children: listUserProfile.map((element) {
                      return InkWell(
                        onTap: () => Navigator.pop(context, element),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 16.0,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(element.name ?? '-'),
                              ),
                              const SizedBox(width: 16),
                              element == selectedUser
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Theme.of(context).colorScheme.primary,
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              );
              if (selectedUserTemp != null) {
                selectedUser = selectedUserTemp;
                setFilterUser();
                setState(() {});
              }
            },
      maxLines: 1,
    );
  }

  void setFilterUser() {
    var name = selectedUser?.name ?? '-';
    if (name.length > 16) {
      name = '${name.substring(0, 16)}...';
    }
    controllerFilterUser.text = name;
  }

  Widget buildWidgetListData(List<ItemTrackUserResponse> listTracks) {
    if (listTracks.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(helper.getDefaultPaddingLayout),
        child: WidgetError(
          title: 'info'.tr(),
          message: 'no_data_to_display'.tr(),
        ),
      );
    }

    var totalTimeInSeconds = 0;
    var averageActivity = 0.0;
    var totalIdleTimeInSeconds = 0;
    for (final element in listTracks) {
      final durationInSeconds = element.durationInSeconds ?? 0;
      totalTimeInSeconds += durationInSeconds;

      final activityInPercent = element.activityInPercent ?? 0;
      averageActivity += activityInPercent;

      if (activityInPercent == 0) {
        totalIdleTimeInSeconds += durationInSeconds;
      }
    }
    final totalTime = helper.convertSecondToHms(totalTimeInSeconds);
    final totalTimeHour = totalTime.hour;
    final totalTimeMinute = totalTime.minute;
    final totalTimeSecond = totalTime.second;
    var strTotalTime = '';
    strTotalTime += totalTimeHour < 10 ? '0$totalTimeHour' : totalTimeHour.toString();
    strTotalTime += ':';
    strTotalTime += totalTimeMinute < 10 ? '0$totalTimeMinute' : totalTimeMinute.toString();
    strTotalTime += ':';
    strTotalTime += totalTimeSecond < 10 ? '0$totalTimeSecond' : totalTimeSecond.toString();

    // rumus mencari nilai rata-rata
    // average = jumlah data / banyak data
    // e.g. 59 + 78 + 94 = 231% = 77%
    var strAverageActivity = (averageActivity / listTracks.length).toStringAsFixed(2);
    if (strAverageActivity.endsWith('0')) {
      strAverageActivity = strAverageActivity.substring(0, strAverageActivity.length - 1);
    }

    final totalIdleTime = helper.convertSecondToHms(totalIdleTimeInSeconds);
    final totalIdleTimeHour = totalIdleTime.hour;
    final totalIdleTimeMinute = totalIdleTime.minute;
    final totalIdleTimeSecond = totalIdleTime.second;
    var strTotalIdleTime = '';
    strTotalIdleTime += totalIdleTimeHour < 10 ? '0$totalIdleTimeHour' : totalIdleTimeHour.toString();
    strTotalIdleTime += ':';
    strTotalIdleTime += totalIdleTimeMinute < 10 ? '0$totalIdleTimeMinute' : totalIdleTimeMinute.toString();
    strTotalIdleTime += ':';
    strTotalIdleTime += totalIdleTimeSecond < 10 ? '0$totalIdleTimeSecond' : totalIdleTimeSecond.toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: helper.getDefaultPaddingLayout),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildWidgetLabelValue(
                'total_time'.tr(),
                strTotalTime,
              ),
              buildWidgetDividerVertical(),
              buildWidgetLabelValue(
                'idle_time'.tr(),
                strTotalIdleTime,
              ),
              buildWidgetDividerVertical(),
              buildWidgetLabelValue(
                'avg_activity'.tr(),
                '$strAverageActivity%',
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: AlignedGridView.count(
            crossAxisCount: 2,
            padding: EdgeInsets.only(
              left: helper.getDefaultPaddingLayout,
              top: helper.getDefaultPaddingLayout,
              right: helper.getDefaultPaddingLayout,
              bottom: helper.getDefaultPaddingLayoutBottom,
            ),
            mainAxisSpacing: helper.getDefaultPaddingLayout,
            crossAxisSpacing: helper.getDefaultPaddingLayout,
            itemCount: listTracks.length,
            itemBuilder: (context, index) {
              final element = listTracks[index];
              final projectName = element.projectName ?? '-';
              final taskName = element.taskName ?? '-';
              final strStartDate = element.startDate ?? '';
              final strFinishDate = element.finishDate ?? '';
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
              final durationInSeconds = element.durationInSeconds ?? 0;
              final activity = element.activityInPercent ?? 0;

              String? thumbnail;
              final listFiles = element.files ?? [];
              if (listFiles.isNotEmpty) {
                thumbnail = listFiles.first.url;
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
                              child: Image.network(
                                thumbnail ?? '',
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
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return SizedBox(
                                    height: heightImage,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1,
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                                loadingProgress.expectedTotalBytes!
                                            : null,
                                      ),
                                    ),
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
                                  PhotoViewPage.parameterListPhotos:
                                      listFiles.where((element) => element.url != null).map((e) => e.url!).toList(),
                                },
                              );
                            },
                            child: Container(
                              height: heightImage,
                            ),
                          ),
                        ),
                        buildWidgetCountScreen(heightImage, listFiles),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildWidgetDividerVertical() {
    return Container(
      width: 0.5,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }

  Widget buildWidgetLabelValue(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
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

  Widget buildWidgetTaskName(String taskName) {
    return Text(
      taskName,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
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

  Widget buildWidgetCountScreen(double heightImage, List<ItemFileTrackUserResponse> listFiles) {
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
}
