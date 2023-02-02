import 'package:flutter/material.dart';

class WidgetError extends StatelessWidget {
  final String message;

  const WidgetError({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message),
    );
  }
}
