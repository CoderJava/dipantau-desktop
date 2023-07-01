import 'package:dipantau_desktop_client/core/util/string_extension.dart';
import 'package:dipantau_desktop_client/feature/presentation/widget/widget_primary_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class WidgetError extends StatelessWidget {
  final String title;
  final String message;
  final Function()? onTryAgain;

  const WidgetError({
    Key? key,
    required this.title,
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
          Text(
            message.setTitleErrorMessage(title).hideResponseCode(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            message.convertErrorMessageToHumanMessage().hideResponseCode(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          onTryAgain == null
              ? Container()
              : WidgetPrimaryButton(
                  onPressed: onTryAgain,
                  child: Text('try_again'.tr()),
                ),
        ],
      ),
    );
  }
}
