import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/core/util/widget_helper.dart';
import 'package:dipantau_desktop_client/feature/presentation/page/home/home_page.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_primary_button.dart';
import 'package:dipantau_desktop_client/injection_container.dart' as di;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SetupCredentialPage extends StatefulWidget {
  static const routePath = '/setup-credential';
  static const routeName = 'setup-credential';
  static const parameterIsFromSplashScreen = 'is_from_splash_screen';
  static const parameterIsShowWarning = 'is_show_warning';

  final bool isFromSplashScreen;
  final bool isShowWarning;

  const SetupCredentialPage({
    Key? key,
    this.isFromSplashScreen = false,
    this.isShowWarning = false,
  }) : super(key: key);

  @override
  State<SetupCredentialPage> createState() => _SetupCredentialPageState();
}

class _SetupCredentialPageState extends State<SetupCredentialPage> {
  final helper = di.sl<Helper>();
  final controllerHostname = TextEditingController();
  final widgetHelper = WidgetHelper();
  final sharedPreferencesManager = di.sl<SharedPreferencesManager>();
  final formState = GlobalKey<FormState>();

  var isLogin = false;
  var defaultDomainApi = '';

  @override
  void initState() {
    isLogin = sharedPreferencesManager.getBool(SharedPreferencesManager.keyIsLogin) ?? false;
    defaultDomainApi = sharedPreferencesManager.getString(SharedPreferencesManager.keyDomainApi) ?? '';
    if (defaultDomainApi.isNotEmpty) {
      controllerHostname.text = defaultDomainApi;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(helper.getDefaultPaddingLayout),
        child: Stack(
          children: [
            widget.isFromSplashScreen
                ? Container()
                : Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back_ios,
                      ),
                    ),
                  ),
            SizedBox(
              width: double.infinity,
              child: Form(
                key: formState,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildWidgetTitle(),
                    const SizedBox(height: 8),
                    Text(
                      'subtitle_set_hostname'.tr(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    buildWidgetTextFieldHostname(),
                    const SizedBox(height: 24),
                    buildWidgetButtonSave(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text buildWidgetTitle() {
    var title = widget.isFromSplashScreen ? 'getting_started'.tr() : 'set_hostname'.tr();
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  Widget buildWidgetTextFieldHostname() {
    return TextFormField(
      autofocus: true,
      controller: controllerHostname,
      decoration:
          widgetHelper.setDefaultTextFieldDecoration(labelText: 'hostname'.tr(), hintText: 'example_hostname'.tr()),
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.go,
      onFieldSubmitted: (_) {
        saveHostname();
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'invalid_hostname'.tr();
        }
        return null;
      },
    );
  }

  Future<void> saveHostname() async {
    if (formState.currentState!.validate()) {
      bool? isContinue = true;
      if (widget.isShowWarning) {
        isContinue = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'warning'.tr(),
              ),
              content: Text(
                'warning_change_hostname'.tr(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('cancel'.tr()),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('restart_app'.tr()),
                ),
              ],
            );
          },
        ) as bool?;
      }
      if (isContinue != null && isContinue) {
        final hostname = controllerHostname.text.trim();
        await sharedPreferencesManager.putString(SharedPreferencesManager.keyDomainApi, hostname);
        helper.setDomainApiToFlavor(hostname);
        await di.init();
        if (mounted) {
          if (isLogin) {
            context.go(HomePage.routePath);
          } else {
            context.go('/');
          }
        }
      }
    }
  }

  Widget buildWidgetButtonSave() {
    return SizedBox(
      width: double.infinity,
      child: WidgetPrimaryButton(
        onPressed: saveHostname,
        child: Text(
          'save'.tr(),
        ),
      ),
    );
  }
}
