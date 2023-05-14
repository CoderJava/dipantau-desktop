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
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[700],
            ),
          ),
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
