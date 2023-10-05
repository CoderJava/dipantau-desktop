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
  final controllerStartDate = TextEditingController();
  final controllerStartTime = TextEditingController();
  final controllerFinishDate = TextEditingController();
  final controllerFinishTime = TextEditingController();
  final controllerDuration = TextEditingController();
  final controllerNote = TextEditingController();
  final valueNotifierEnableButtonSave = ValueNotifier(false);

  var isLoading = false;
  var userId = '';
  ProjectTaskResponse? projectTask;
  _ItemData? selectedProject, selectedTask;
  DateTime? startDate, finishDate;
  TimeOfDay? startTime, finishTime;
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
            final errorMessage = state.errorMessage.convertErrorMessageToHumanMessage();
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: helper.getDefaultPaddingLayout),
              child: WidgetError(
                title: 'oops'.tr(),
                message: errorMessage.hideResponseCode(),
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
          Row(
            children: [
              Expanded(
                child: buildWidgetField(
                  controllerStartDate,
                  label: 'start_date'.tr(),
                  hint: 'set_start_date'.tr(),
                  validator: (value) {
                    return value == null ? 'please_set_start_date'.tr() : null;
                  },
                  onTap: () async {
                    final now = DateTime.now();
                    final firstDate = now.subtract(const Duration(days: 30));
                    final selectedStartDate = await showDatePicker(
                      context: context,
                      initialDate: startDate ?? now,
                      firstDate: firstDate,
                      lastDate: now,
                    );
                    if (selectedStartDate != null) {
                      startDate = selectedStartDate;
                      checkIfStartAfterFinishDateTime();
                      controllerStartDate.text = helper.setDateFormat('EEEE dd MMM yyyy').format(startDate!);
                      calculateDuration();
                      doCheckEnableButtonSubmit();
                      setState(() {});
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: buildWidgetField(
                  controllerStartTime,
                  label: 'start_time'.tr(),
                  hint: 'set_start_time'.tr(),
                  validator: (value) {
                    return value == null ? 'please_set_start_time'.tr() : null;
                  },
                  onTap: () async {
                    TimeOfDay initialTime = TimeOfDay.now();
                    if (startTime != null) {
                      initialTime = TimeOfDay(
                        hour: startTime!.hour,
                        minute: startTime!.minute,
                      );
                    }
                    final selectedStartTime = await showTimePicker(
                      context: context,
                      initialTime: initialTime,
                      initialEntryMode: TimePickerEntryMode.input,
                    );
                    if (selectedStartTime != null) {
                      startTime = TimeOfDay(
                        hour: selectedStartTime.hour,
                        minute: selectedStartTime.minute,
                      );
                      final startDateTime = DateTime(
                        startDate!.year,
                        startDate!.month,
                        startDate!.day,
                        startTime!.hour,
                        startTime!.minute,
                        0,
                      );
                      checkIfStartAfterFinishDateTime();
                      controllerStartTime.text = helper.setDateFormat('HH:mm').format(startDateTime);
                      calculateDuration();
                      doCheckEnableButtonSubmit();
                      setState(() {});
                    }
                  },
                  isEnabled: startDate != null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: buildWidgetField(
                  controllerFinishDate,
                  label: 'finish_date'.tr(),
                  hint: 'set_finish_date'.tr(),
                  validator: (value) {
                    return value == null ? 'please_set_finish_date'.tr() : null;
                  },
                  onTap: () async {
                    final firstDate = DateTime(
                      startDate!.year,
                      startDate!.month,
                      startDate!.day,
                      startTime!.hour,
                      startTime!.minute,
                      0,
                    );
                    firstDate.add(const Duration(minutes: 1));
                    final selectedFinishDate = await showDatePicker(
                      context: context,
                      initialDate: finishDate ?? firstDate,
                      firstDate: firstDate,
                      lastDate: firstDate.add(const Duration(days: 1)),
                    );
                    if (selectedFinishDate != null) {
                      finishDate = selectedFinishDate;
                      controllerFinishDate.text = helper.setDateFormat('EEEE dd MMM yyyy').format(finishDate!);
                      final isFinishBeforeStart = isFinishBeforeStartDateTime();
                      if (isFinishBeforeStart) {
                        finishTime = null;
                        controllerFinishTime.text = '';
                        if (mounted) {
                          showDialogValidationTime();
                        }
                        return;
                      }

                      calculateDuration();
                      doCheckEnableButtonSubmit();
                      setState(() {});
                    }
                  },
                  isEnabled: startDate != null && startTime != null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: buildWidgetField(
                  controllerFinishTime,
                  label: 'finish_time'.tr(),
                  hint: 'set_finish_time'.tr(),
                  validator: (value) {
                    return value == null ? 'please_set_finish_time'.tr() : null;
                  },
                  onTap: () async {
                    DateTime startDateTime = DateTime(
                      startDate!.year,
                      startDate!.month,
                      startDate!.day,
                      startTime!.hour,
                      startTime!.minute,
                      0,
                    );
                    startDateTime = startDateTime.add(const Duration(minutes: 1));

                    TimeOfDay initialTime = TimeOfDay(
                      hour: startDateTime.hour,
                      minute: startDateTime.minute,
                    );
                    if (finishTime != null) {
                      initialTime = TimeOfDay(
                        hour: finishTime!.hour,
                        minute: finishTime!.minute,
                      );
                    }
                    final selectedFinishTime = await showTimePicker(
                      context: context,
                      initialTime: initialTime,
                      initialEntryMode: TimePickerEntryMode.input,
                    );
                    if (selectedFinishTime != null) {
                      finishTime = TimeOfDay(
                        hour: selectedFinishTime.hour,
                        minute: selectedFinishTime.minute,
                      );
                      final finishDateTime = DateTime(
                        finishDate!.year,
                        finishDate!.month,
                        finishDate!.day,
                        finishTime!.hour,
                        finishTime!.minute,
                        0,
                      );
                      controllerFinishTime.text = helper.setDateFormat('HH:mm').format(finishDateTime);
                      final isFinishBeforeStart = isFinishBeforeStartDateTime();
                      if (isFinishBeforeStart) {
                        finishTime = null;
                        controllerFinishTime.text = '';
                        if (mounted) {
                          showDialogValidationTime();
                        }
                        return;
                      }

                      calculateDuration();
                      doCheckEnableButtonSubmit();
                      setState(() {});
                    }
                  },
                  isEnabled: startDate != null && startTime != null && finishDate != null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          buildWidgetField(
            controllerDuration,
            label: 'duration'.tr(),
            hint: 'set_start_and_finish_time'.tr(),
            isEnabled: false,
          ),
          const SizedBox(height: 24),
          buildWidgetField(
            controllerNote,
            label: 'reason'.tr(),
            hint: 'why_are_you_adding_manual_track'.tr(),
            isEnabled: true,
            readOnly: false,
            maxLength: 100,
            onChanged: (_) {
              doCheckEnableButtonSubmit();
            },
          ),
          const SizedBox(height: 24),
          buildWidgetButtonSave(),
        ],
      ),
    );
  }

  void showDialogValidationTime() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('warning'.tr()),
          content: Text(
            'finish_date_time_must_be_after_of_start_date_time'.tr(),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: Text('ok'.tr()),
            ),
          ],
        );
      },
    );
  }

  bool isFinishBeforeStartDateTime() {
    if (startDate != null && startTime != null && finishDate != null && finishTime != null) {
      final startDateTime = DateTime(
        startDate!.year,
        startDate!.month,
        startDate!.day,
        startTime!.hour,
        startTime!.minute,
        0,
      );
      final finishDateTime = DateTime(
        finishDate!.year,
        finishDate!.month,
        finishDate!.day,
        finishTime!.hour,
        finishTime!.minute,
        0,
      );
      if (finishDateTime.isBefore(startDateTime) || finishDateTime.isAtSameMomentAs(startDateTime)) {
        return true;
      }
    }
    return false;
  }

  void checkIfStartAfterFinishDateTime() {
    if (finishDate != null && finishTime != null && startDate != null && startTime != null) {
      final startDateTime = DateTime(
        startDate!.year,
        startDate!.month,
        startDate!.day,
        startTime!.hour,
        startTime!.minute,
        0,
      );
      final finishDateTime = DateTime(
        finishDate!.year,
        finishDate!.month,
        finishDate!.day,
        finishTime!.hour,
        finishTime!.minute,
        0,
      );
      if (startDateTime.isAfter(finishDateTime)) {
        finishDate = null;
        finishTime = null;
        controllerFinishDate.text = '';
        controllerFinishTime.text = '';
      }
    }
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
    final timezoneOffsetInSeconds = startDate!.timeZoneOffset.inSeconds;
    final timezoneOffset = helper.convertSecondToHms(timezoneOffsetInSeconds);
    var strTimezoneOffset = timezoneOffsetInSeconds >= 0 ? '+' : '-';
    strTimezoneOffset += timezoneOffset.hour < 10 ? '0${timezoneOffset.hour}' : timezoneOffset.hour.toString();
    strTimezoneOffset += ':';
    strTimezoneOffset += timezoneOffset.minute < 10 ? '0${timezoneOffset.minute}' : timezoneOffset.minute.toString();

    const datePattern = 'yyyy-MM-dd';
    const timePattern = 'HH:mm:ss';
    final startDateTime = DateTime(
      startDate!.year,
      startDate!.month,
      startDate!.day,
      startTime!.hour,
      startTime!.minute,
      0,
    );
    final finishDateTime = DateTime(
      finishDate!.year,
      finishDate!.month,
      finishDate!.day,
      finishTime!.hour,
      finishTime!.minute,
      0,
    );
    final strStartDate = helper.setDateFormat(datePattern).format(startDateTime);
    final strStartTime = helper.setDateFormat(timePattern).format(startDateTime);
    final strFinishDate = helper.setDateFormat(datePattern).format(finishDateTime);
    final strFinishTime = helper.setDateFormat(timePattern).format(finishDateTime);
    final formattedStartDateTime = '${strStartDate}T$strStartTime$strTimezoneOffset';
    final formattedFinishDateTime = '${strFinishDate}T$strFinishTime$strTimezoneOffset';
    final body = ManualCreateTrackBody(
      taskId: selectedTask!.id,
      startDate: formattedStartDateTime,
      finishDate: formattedFinishDateTime,
      duration: durationInSeconds!,
      note: controllerNote.text.trim(),
    );
    manualTrackingBloc.add(
      CreateManualTrackingEvent(
        body: body,
      ),
    );
  }

  void calculateDuration() {
    if (startDate != null && startTime != null && finishDate != null && finishTime != null) {
      final startDateTime = DateTime(
        startDate!.year,
        startDate!.month,
        startDate!.day,
        startTime!.hour,
        startTime!.minute,
        0,
      );
      final finishDateTime = DateTime(
        finishDate!.year,
        finishDate!.month,
        finishDate!.day,
        finishTime!.hour,
        finishTime!.minute,
        0,
      );
      durationInSeconds = startDateTime.difference(finishDateTime).inSeconds.abs();
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
    bool readOnly = true,
    int? maxLength,
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      decoration: widgetHelper.setDefaultTextFieldDecoration(
        labelText: label,
        hintText: hint,
      ),
      readOnly: readOnly,
      mouseCursor: MaterialStateMouseCursor.clickable,
      onTap: onTap,
      validator: validator,
      enabled: isEnabled,
      maxLength: maxLength,
      onChanged: onChanged,
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
      hint: Text(hintText),
      decoration: widgetHelper.setDefaultTextFieldDecoration(
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  void doCheckEnableButtonSubmit() {
    var isEnableTemp = false;
    final reason = controllerNote.text.trim();
    if (selectedProject != null &&
        selectedTask != null &&
        startDate != null &&
        finishDate != null &&
        durationInSeconds != null &&
        durationInSeconds! > 0 &&
        reason.isNotEmpty) {
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
