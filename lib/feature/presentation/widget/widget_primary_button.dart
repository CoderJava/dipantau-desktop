import 'package:dipantau_desktop_client/feature/presentation/widget/widget_custom_circular_progress_indicator.dart';
import 'package:flutter/material.dart';

class WidgetPrimaryButton extends StatelessWidget {
  final Function()? onPressed;
  final Widget child;
  final bool? isLoading;

  const WidgetPrimaryButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        child: isLoading != null && isLoading! ? buildWidgetLoading() : child,
      ),
    );
  }

  Widget buildWidgetLoading() {
    return const SizedBox(
      width: 24,
      height: 24,
      child: WidgetCustomCircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }
}
