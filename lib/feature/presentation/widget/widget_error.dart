import 'package:dipantau_desktop_client/feature/presentation/widget/widget_primary_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class WidgetError extends StatelessWidget {
  final String message;
  final Function()? onTryAgain;

  const WidgetError({
    Key? key,
    required this.message,
    this.onTryAgain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          onTryAgain == null ? Container() : WidgetPrimaryButton(
            onPressed: onTryAgain,
            child: Text('try_again'.tr()),
          ),
        ],
      ),
    );
  }
}
