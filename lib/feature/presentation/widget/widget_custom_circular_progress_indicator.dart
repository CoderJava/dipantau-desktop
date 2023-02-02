import 'package:flutter/material.dart';

class WidgetCustomCircularProgressIndicator extends StatelessWidget {
  final Color? color;

  const WidgetCustomCircularProgressIndicator({
    Key? key,
    this.color,
  }) : super(key: key);

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
