import 'package:flutter/material.dart';

class WidgetIconCircle extends StatelessWidget {
  final IconData iconData;
  final double size;
  final double padding;

  const WidgetIconCircle({
    required this.iconData,
    this.size = 32.0,
    this.padding = 16.0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.primary),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        color: Theme.of(context).colorScheme.primary,
        size: size,
      ),
    );
  }
}
