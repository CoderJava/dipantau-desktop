import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/feature/data/model/project/project_response.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/project/project_bloc.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_custom_circular_progress_indicator.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_error.dart';
import 'package:dipantau_desktop_client/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WidgetChooseProject extends StatefulWidget {
  final int? defaultSelectedProjectId;

  const WidgetChooseProject({
    required this.defaultSelectedProjectId,
    Key? key,
  }) : super(key: key);

  @override
  State<WidgetChooseProject> createState() => _WidgetChooseProjectState();
}

class _WidgetChooseProjectState extends State<WidgetChooseProject> {
  final helper = sl<Helper>();
  final projectBloc = sl<ProjectBloc>();

  ProjectResponse? projectResponse;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    doLoadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProjectBloc>(
      create: (context) => projectBloc,
      child: BlocListener<ProjectBloc, ProjectState>(
        listener: (context, state) {
          if (state is SuccessLoadDataProjectState) {
            projectResponse = state.project;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'choose_project'.tr(),
            ),
            centerTitle: false,
          ),
          body: SizedBox(
            width: double.infinity,
            child: BlocBuilder<ProjectBloc, ProjectState>(
              builder: (context, state) {
                if (state is LoadingProjectState) {
                  return const WidgetCustomCircularProgressIndicator();
                } else if (state is FailureProjectState) {
                  final errorMessage = state.errorMessage;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: helper.getDefaultPaddingLayout),
                    child: WidgetError(
                      title: 'info'.tr(),
                      message: errorMessage,
                    ),
                  );
                } else if (state is SuccessLoadDataProjectState) {
                  return buildWidgetData();
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }

  void doLoadData() {
    projectBloc.add(LoadDataProjectEvent());
  }

  Widget buildWidgetData() {
    final listProjects = projectResponse?.data ?? <ItemProjectResponse>[];
    if (listProjects.isEmpty) {
      return WidgetError(
        title: 'info'.tr(),
        message: 'no_data_to_display'.tr(),
      );
    }
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: ListView.separated(
        padding: EdgeInsets.only(
          left: helper.getDefaultPaddingLayout,
          top: helper.getDefaultPaddingLayoutTop,
          right: helper.getDefaultPaddingLayout,
          bottom: helper.getDefaultPaddingLayout,
        ),
        itemBuilder: (context, index) {
          final project = listProjects[index];
          final projectId = project.id;
          if (projectId == null) {
            return Container();
          }

          return InkWell(
            onTap: () {
              Navigator.pop(context, project);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      project.name ?? '-',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 16),
                  widget.defaultSelectedProjectId == projectId
                      ? Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : Container(),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemCount: listProjects.length,
      ),
    );
  }
}
