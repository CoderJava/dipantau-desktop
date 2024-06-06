import 'package:dipantau_desktop_client/feature/presentation/widget/widget_custom_circular_progress_indicator.dart';
import 'package:flutter/material.dart';

class WidgetLoadingCenterFullScreen extends StatelessWidget {
  const WidgetLoadingCenterFullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withOpacity(.5),
      child: const WidgetCustomCircularProgressIndicator(),
    );
  }
}
