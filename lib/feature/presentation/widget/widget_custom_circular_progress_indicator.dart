import 'package:flutter/material.dart';

class WidgetCustomCircularProgressIndicator extends StatelessWidget {
  final Color? color;

  const WidgetCustomCircularProgressIndicator({
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 1,
        color: color,
      ),
    );
  }
}
