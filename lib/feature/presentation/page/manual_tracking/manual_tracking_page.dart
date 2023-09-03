import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/core/util/string_extension.dart';
import 'package:dipantau_desktop_client/core/util/widget_helper.dart';
import 'package:dipantau_desktop_client/feature/data/model/manual_create_track/manual_create_track_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/project_task/project_task_response.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/manual_tracking/manual_tracking_bloc.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_custom_circular_progress_indicator.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_error.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_primary_button.dart';
import 'package:dipantau_desktop_client/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class ManualTrackingPage extends StatefulWidget {
  static const routePath = '/manual-tracking';
  static const routeName = 'manual-tracking';

  const ManualTrackingPage({Key? key}) : super(key: key);

  @override
  State<ManualTrackingPage> createState() => _ManualTrackingPageState();
}

class _ManualTrackingPageState extends State<ManualTrackingPage> {
  final manualTrackingBloc = sl<ManualTrackingBloc>();
  final widgetHelper = WidgetHelper();
  final formState = GlobalKey<FormState>();
  final helper = sl<Helper>();
  final sharedPreferencesManager = sl<SharedPreferencesManager>();
  final projectItems = <_ItemData>[];
  final taskItems = <_ItemData>[];
  final controllerStartTime = TextEditingController();
  final controllerFinishTime = TextEditingController();
  final controllerDuration = TextEditingController();
  final valueNotifierEnableButtonSave = ValueNotifier(false);

  var isLoading = false;
  var userId = '';
  ProjectTaskResponse? projectTask;
  _ItemData? selectedProject, selectedTask;
  DateTime? startDateTime, finishDateTime;
  int? durationInSeconds;

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

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isLoading,
      child: BlocProvider<ManualTrackingBloc>(
        create: (context) => manualTrackingBloc,
        child: BlocListener<ManualTrackingBloc, ManualTrackingState>(
          listener: (context, state) {
            setState(() => isLoading = state is LoadingManualTrackingState);
            if (state is FailureManualTrackingState) {
              final errorMessage = state.errorMessage.convertErrorMessageToHumanMessage();
              if (errorMessage.contains('401')) {
                widgetHelper.showDialog401(context);
                return;
              }
              widgetHelper.showSnackBar(context, errorMessage.hideResponseCode());
            } else if (state is SuccessCreateManualTrackingState) {
              widgetHelper.showSnackBar(context, 'add_manual_track_successfully'.tr());
              context.pop();
            } else if (state is SuccessLoadDataProjectTaskManualTrackingState) {
              projectTask = state.response;
              projectItems.clear();
              taskItems.clear();
              for (final element in projectTask?.data ?? <ItemProjectTaskResponse>[]) {
                final projectId = element.projectId;
                final projectName = element.projectName;
                if (projectId == null || projectName == null || projectName.isEmpty) {
                  continue;
                }
                projectItems.add(
                  _ItemData(
                    id: projectId,
                    name: projectName,
                  ),
                );
              }
              setState(() {});
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text('add_manual_track'.tr()),
              centerTitle: false,
            ),
            body: buildWidgetBody(),
          ),
        ),
      ),
    );
  }

  Widget buildWidgetBody() {
    if (projectTask == null) {
      return BlocBuilder<ManualTrackingBloc, ManualTrackingState>(
        builder: (context, state) {
          if (state is LoadingManualTrackingState) {
            return const WidgetCustomCircularProgressIndicator();
          } else if (state is FailureCenterManualTrackingState) {
            final errorMessage = state.errorMessage;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: helper.getDefaultPaddingLayout),
              child: WidgetError(
                title: 'oops'.tr(),
                message: errorMessage,
                onTryAgain: doLoadData,
              ),
            );
          }
          return Container();
        },
      );
    }

    return BlocBuilder<ManualTrackingBloc, ManualTrackingState>(
      builder: (context, state) {
        return buildWidgetForm();
      },
    );
  }

  Widget buildWidgetForm() {
    return Form(
      key: formState,
      child: ListView(
        padding: EdgeInsets.all(helper.getDefaultPaddingLayout),
        children: [
          buildWidgetFieldDropdown(
            selectedProject,
            projectItems,
            labelText: 'project'.tr(),
            hintText: 'select_project'.tr(),
            onChanged: (value) {
              if (value != null && selectedProject != null && value.id == selectedProject?.id) {
                /* Nothing to do in here */
                return;
              }
              selectedProject = value;
              selectedTask = null;
              taskItems.clear();
              final listTasks = projectTask?.data?.where((element) {
                final projectId = element.projectId;
                return projectId != null && projectId == selectedProject?.id;
              }).map((e) => e.tasks);
              if (listTasks != null && listTasks.isNotEmpty) {
                final tasks = listTasks.first;
                for (final task in tasks) {
                  final taskId = task.id;
                  final taskName = task.name;
                  if (taskId == null || taskName == null || taskName.isEmpty) {
                    continue;
                  }
                  taskItems.add(
                    _ItemData(
                      id: taskId,
                      name: taskName,
                    ),
                  );
                }
                if (taskItems.isNotEmpty) {
                  selectedTask = taskItems.first;
                }
              }
              doCheckEnableButtonSubmit();
              setState(() {});
            },
            validator: (value) {
              return value == null ? 'please_choose_a_project'.tr() : null;
            },
          ),
          const SizedBox(height: 24),
          buildWidgetFieldDropdown(
            selectedTask,
            taskItems,
            labelText: 'task'.tr(),
            hintText: selectedProject == null
                ? 'select_a_project_first'.tr()
                : taskItems.isEmpty
                    ? 'no_data_available'.tr()
                    : 'select_task'.tr(),
            onChanged: (value) {
              selectedTask = value;
              doCheckEnableButtonSubmit();
              setState(() {});
            },
            validator: (value) {
              return value == null ? 'please_choose_a_task'.tr() : null;
            },
          ),
          const SizedBox(height: 24),
          buildWidgetField(
            controllerStartTime,
            label: 'start_time'.tr(),
            hint: 'set_start_time'.tr(),
            validator: (value) {
              return value == null ? 'please_set_start_time'.tr() : null;
            },
            onTap: () async {
              final now = DateTime.now();
              final firstDate = now.subtract(const Duration(days: 30));
              final selectedStartDateTime = await showOmniDateTimePicker(
                context: context,
                initialDate: startDateTime ?? now,
                firstDate: firstDate,
                lastDate: now,
                is24HourMode: true,
                separator: const Divider(),
              );
              if (selectedStartDateTime != null) {
                startDateTime = selectedStartDateTime;
                if (finishDateTime != null && startDateTime!.isAfter(finishDateTime!)) {
                  finishDateTime = null;
                  controllerFinishTime.text = '';
                }
                controllerStartTime.text = helper.setDateFormat('EEE dd MMM yyyy HH:mm').format(startDateTime!);
                calculateDuration();
                doCheckEnableButtonSubmit();
                setState(() {});
              }
            },
          ),
          const SizedBox(height: 24),
          buildWidgetField(
            controllerFinishTime,
            label: 'finish_time'.tr(),
            hint: 'set_finish_time'.tr(),
            validator: (value) {
              return value == null ? 'please_set_finish_time'.tr() : null;
            },
            onTap: () async {
              final now = DateTime.now();
              final firstDate = now.subtract(const Duration(days: 30));
              final selectedFinishTime = await showOmniDateTimePicker(
                context: context,
                initialDate: finishDateTime ?? now,
                firstDate: firstDate,
                lastDate: now,
                is24HourMode: true,
                separator: const Divider(),
              );
              if (selectedFinishTime != null) {
                finishDateTime = selectedFinishTime;
                if (startDateTime != null && finishDateTime!.isBefore(startDateTime!)) {
                  startDateTime = null;
                  controllerStartTime.text = '';
                }
                controllerFinishTime.text = helper.setDateFormat('EEE dd MMM yyyy HH:mm').format(finishDateTime!);
                calculateDuration();
                doCheckEnableButtonSubmit();
                setState(() {});
              }
            },
            isEnabled: startDateTime != null,
          ),
          const SizedBox(height: 24),
          buildWidgetField(
            controllerDuration,
            label: 'duration'.tr(),
            hint: 'set_start_and_finish_time'.tr(),
            isEnabled: false,
          ),
          const SizedBox(height: 24),
          buildWidgetButtonSave(),
        ],
      ),
    );
  }

  Widget buildWidgetButtonSave() {
    final widgetButton = ValueListenableBuilder(
      valueListenable: valueNotifierEnableButtonSave,
      builder: (BuildContext context, bool isEnable, _) {
        return SizedBox(
          width: double.infinity,
          child: WidgetPrimaryButton(
            onPressed: isEnable ? doSave : null,
            isLoading: isLoading,
            child: Text(
              'save'.tr(),
            ),
          ),
        );
      },
    );

    return BlocBuilder<ManualTrackingBloc, ManualTrackingState>(
      builder: (context, state) {
        return widgetButton;
      },
    );
  }

  void doSave() {
    final timezoneOffsetInSeconds = startDateTime!.timeZoneOffset.inSeconds;
    final timezoneOffset = helper.convertSecondToHms(timezoneOffsetInSeconds);
    var strTimezoneOffset = timezoneOffsetInSeconds >= 0 ? '+' : '-';
    strTimezoneOffset += timezoneOffset.hour < 10 ? '0${timezoneOffset.hour}' : timezoneOffset.hour.toString();
    strTimezoneOffset += ':';
    strTimezoneOffset += timezoneOffset.minute < 10 ? '0${timezoneOffset.minute}' : timezoneOffset.minute.toString();

    const datePattern = 'yyyy-MM-dd';
    const timePattern = 'HH:mm:ss';
    final strStartDate = helper.setDateFormat(datePattern).format(startDateTime!);
    final strStartTime = helper.setDateFormat(timePattern).format(startDateTime!);
    final strFinishDate = helper.setDateFormat(datePattern).format(finishDateTime!);
    final strFinishTime = helper.setDateFormat(timePattern).format(finishDateTime!);
    final formattedStartDateTime = '${strStartDate}T$strStartTime$strTimezoneOffset';
    final formattedFinishDateTime = '${strFinishDate}T$strFinishTime$strTimezoneOffset';
    final body = ManualCreateTrackBody(
      taskId: selectedTask!.id,
      startDate: formattedStartDateTime,
      finishDate: formattedFinishDateTime,
      duration: durationInSeconds!,
    );
    manualTrackingBloc.add(
      CreateManualTrackingEvent(
        body: body,
      ),
    );
  }

  void calculateDuration() {
    if (startDateTime != null && finishDateTime != null) {
      durationInSeconds = startDateTime!.difference(finishDateTime!).inSeconds.abs();
      final mapDuration = helper.convertSecondToHms(durationInSeconds!);
      final hour = mapDuration.hour;
      final minute = mapDuration.minute;
      final second = mapDuration.second;
      final listStrDuration = <String>[];
      if (hour > 0) {
        listStrDuration.add('hour_n'.plural(hour));
      }
      if (minute > 0) {
        listStrDuration.add('minute_n'.plural(minute));
      }
      if (second > 0) {
        listStrDuration.add('second_n'.plural(second));
      }
      var strDuration = '';
      if (listStrDuration.isNotEmpty) {
        strDuration = listStrDuration.join(' ');
      } else {
        strDuration = '';
      }
      controllerDuration.text = strDuration;
    } else {
      durationInSeconds = null;
      controllerDuration.text = '';
    }
  }

  Widget buildWidgetField(
    TextEditingController controller, {
    required String label,
    required String hint,
    Function()? onTap,
    bool isEnabled = true,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: widgetHelper.setDefaultTextFieldDecoration(
        labelText: label,
        hintText: hint,
      ),
      readOnly: true,
      mouseCursor: MaterialStateMouseCursor.clickable,
      onTap: onTap,
      validator: validator,
      enabled: isEnabled,
    );
  }

  Widget buildWidgetFieldDropdown(
    _ItemData? value,
    List<_ItemData> items, {
    required String labelText,
    required String hintText,
    ValueChanged<_ItemData?>? onChanged,
    FormFieldValidator<_ItemData>? validator,
  }) {
    return DropdownButtonFormField<_ItemData>(
      value: value,
      items: items.map((element) {
        return DropdownMenuItem(
          value: element,
          child: Text(
            element.name,
          ),
        );
      }).toList(),
      onChanged: onChanged,
      selectedItemBuilder: (context) {
        return items.map((element) {
          final name = element.name;
          return Text(name);
        }).toList();
      },
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      padding: EdgeInsets.zero,
      decoration: widgetHelper.setDefaultTextFieldDecoration(
        labelText: labelText,
        hintText: hintText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  void doCheckEnableButtonSubmit() {
    var isEnableTemp = false;
    if (selectedProject != null &&
        selectedTask != null &&
        startDateTime != null &&
        finishDateTime != null &&
        durationInSeconds != null &&
        durationInSeconds! > 0) {
      isEnableTemp = true;
    }
    if (isEnableTemp != valueNotifierEnableButtonSave.value) {
      valueNotifierEnableButtonSave.value = isEnableTemp;
    }
  }

  void doLoadData() {
    manualTrackingBloc.add(
      LoadDataProjectTaskManualTrackingEvent(
        userId: userId,
      ),
    );
  }
}

class _ItemData {
  final int id;
  final String name;

  _ItemData({
    required this.id,
    required this.name,
  });

  @override
  String toString() {
    return '_ItemData{id: $id, name: $name}';
  }
}
