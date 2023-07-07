import 'package:dipantau_desktop_client/core/util/enum/user_role.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/core/util/string_extension.dart';
import 'package:dipantau_desktop_client/core/util/widget_helper.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/member/member_bloc.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/add_member/add_edit_member_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_custom_circular_progress_indicator.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_error.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_primary_button.dart';
import 'package:dipantau_desktop_client/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class MemberSettingPage extends StatefulWidget {
  static const routePath = '/member-setting';
  static const routeName = 'member-setting';

  const MemberSettingPage({Key? key}) : super(key: key);

  @override
  State<MemberSettingPage> createState() => _MemberSettingPageState();
}

class _MemberSettingPageState extends State<MemberSettingPage> {
  final memberBloc = sl<MemberBloc>();
  final widgetHelper = WidgetHelper();
  final helper = sl<Helper>();
  final columns = <DataColumn>[
    DataColumn(
      label: Text('name'.tr()),
    ),
    DataColumn(
      label: Text('role'.tr()),
    ),
    DataColumn(
      label: Text('email_2'.tr()),
    ),
  ];
  final rows = <DataRow>[];

  @override
  void initState() {
    doLoadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('member_setting'.tr()),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: WidgetPrimaryButton(
              onPressed: () {
                context.pushNamed<bool?>(AddEditMemberPage.routeName).then((isRefresh) {
                  if (isRefresh != null) {
                    doLoadData();
                  }
                });
              },
              child: Row(
                children: [
                  const FaIcon(
                    FontAwesomeIcons.penToSquare,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'create'.tr(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: BlocProvider<MemberBloc>(
        create: (context) => memberBloc,
        child: BlocListener<MemberBloc, MemberState>(
          listener: (context, state) {
            if (state is FailureMemberState) {
              final errorMessage = state.errorMessage.convertErrorMessageToHumanMessage();
              if (errorMessage.contains('401')) {
                widgetHelper.showDialog401(context);
                return;
              }
              widgetHelper.showSnackBar(context, errorMessage.hideResponseCode());
            } else if (state is SuccessLoadListMemberState) {
              final data = state.response.data ?? [];
              data.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
              rows.clear();
              for (final itemData in data) {
                final name = itemData.name;
                final role = itemData.role;
                final username = itemData.username;
                if (name == null || role == null || username == null) {
                  continue;
                }

                final cells = <DataCell>[
                  DataCell(
                    SizedBox(
                      width: 92,
                      child: InkWell(
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          context.pushNamed<bool?>(
                            AddEditMemberPage.routeName,
                            extra: {
                              AddEditMemberPage.parameterDefaultValue: itemData,
                            },
                          ).then((bool? isRefresh) {
                            if (isRefresh != null && isRefresh) {
                              doLoadData();
                            }
                          });
                        },
                        child: Text(
                          name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: 72,
                      child: Text(
                        role.toName ?? '-',
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      username,
                    ),
                  ),
                ];
                rows.add(
                  DataRow(
                    cells: cells,
                  ),
                );
              }
            }
          },
          child: BlocBuilder<MemberBloc, MemberState>(
            builder: (context, state) {
              if (state is FailureMemberState) {
                final errorMessage = state.errorMessage;
                return WidgetError(
                  title: 'oops'.tr(),
                  message: errorMessage,
                  onTryAgain: doLoadData,
                );
              } else if (state is LoadingCenterMemberState) {
                return const WidgetCustomCircularProgressIndicator();
              } else if (state is InitialMemberState) {
                return Container();
              }
              return rows.isEmpty
                  ? WidgetError(
                      title: 'info'.tr(),
                      message: 'no_data_to_display'.tr(),
                    )
                  : buildWidgetData();
            },
          ),
        ),
      ),
    );
  }

  void doLoadData() {
    memberBloc.add(LoadListMemberEvent());
  }

  Widget buildWidgetData() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: EdgeInsets.only(
            top: helper.getDefaultPaddingLayoutTop,
            bottom: helper.getDefaultPaddingLayout,
          ),
          child: DataTable(
            columns: columns,
            rows: rows,
            headingTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
            dataRowMaxHeight: 64,
          ),
        ),
      ),
    );
  }
}
