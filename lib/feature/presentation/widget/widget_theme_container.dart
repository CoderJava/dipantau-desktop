import 'package:dipantau_desktop_client/core/util/enum/appearance_mode.dart';
import 'package:flutter/material.dart';

class WidgetThemeContainer extends StatefulWidget {
  final AppearanceMode mode;
  final double width;
  final double height;
  final Color? borderColor;

  const WidgetThemeContainer({
    super.key,
    required this.mode,
    required this.width,
    required this.height,
    this.borderColor,
  });

  @override
  State<WidgetThemeContainer> createState() => _WidgetThemeContainerState();
}

class _WidgetThemeContainerState extends State<WidgetThemeContainer> {
  @override
  Widget build(BuildContext context) {
    Widget child;
    switch (widget.mode) {
      case AppearanceMode.system:
        child = buildWidgetSystem();
        break;
      case AppearanceMode.light:
        child = buildWidgetLight();
        break;
      case AppearanceMode.dark:
        child = buildWidgetDark();
        break;
    }
    return Container(
      decoration: BoxDecoration(
        color: widget.borderColor ?? Colors.grey[400],
        border: Border.all(
          color: widget.borderColor ?? Colors.grey[400]!,
          width: widget.borderColor == null ? 3 : 3,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  Widget buildWidgetSystem() {
    const borderRadius = 16.0;
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Row(
        children: [
          Expanded(
            child: buildWidgetLight(
              customBorderRadiusOuter: const BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                bottomLeft: Radius.circular(borderRadius),
              ),
              customBorderRadiusInner: const BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                bottomLeft: Radius.circular(borderRadius - 8),
              ),
            ),
          ),
          Expanded(
            child: buildWidgetDark(
              customBorderRadiusOuter: const BorderRadius.only(
                topRight: Radius.circular(borderRadius),
                bottomRight: Radius.circular(borderRadius),
              ),
              customBorderRadiusInner: const BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                topRight: Radius.circular(borderRadius - 8),
                bottomRight: Radius.circular(borderRadius),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildWidgetLight({
    BorderRadius? customBorderRadiusOuter,
    BorderRadius? customBorderRadiusInner,
  }) {
    const borderColor = Color(0xFFE3E3E3);
    final backgroundOuterContainer = Colors.grey[300]!;
    const backgroundInsideContainer = Colors.white;
    const textColor = Color(0xFF020202);
    const borderRadius = 16.0;
    return buildWidgetContainerAppearance(
      backgroundOuterContainer,
      borderRadius,
      borderColor,
      backgroundInsideContainer,
      textColor,
      widget.width,
      widget.height,
      borderRadiusOuter: customBorderRadiusOuter,
      borderRadiusInner: customBorderRadiusInner,
    );
  }

  Widget buildWidgetDark({
    BorderRadius? customBorderRadiusOuter,
    BorderRadius? customBorderRadiusInner,
  }) {
    const borderColor = Color(0xFFE3E3E3);
    const backgroundOuterContainer = Color(0xFF454545);
    const backgroundInsideContainer = Color(0xFF161616);
    const textColor = Colors.white;
    const borderRadius = 16.0;
    return buildWidgetContainerAppearance(
      backgroundOuterContainer,
      borderRadius,
      borderColor,
      backgroundInsideContainer,
      textColor,
      widget.width,
      widget.height,
      borderRadiusOuter: customBorderRadiusOuter,
      borderRadiusInner: customBorderRadiusInner,
    );
  }

  Container buildWidgetContainerAppearance(
    Color backgroundOuterContainer,
    double borderRadius,
    Color borderColor,
    Color backgroundInsideContainer,
    Color textColor,
    double width,
    double height, {
    BorderRadius? borderRadiusOuter,
    BorderRadius? borderRadiusInner,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundOuterContainer,
        borderRadius: borderRadiusOuter ?? BorderRadius.circular(borderRadius),
      ),
      padding: const EdgeInsets.only(
        left: 8,
        top: 8,
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: backgroundInsideContainer,
          borderRadius: borderRadiusInner ??
              BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                topRight: Radius.circular(borderRadius - 8),
                bottomRight: Radius.circular(borderRadius),
                bottomLeft: Radius.circular(borderRadius - 8),
              ),
        ),
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.only(
          left: 8,
          top: 8,
        ),
        child: Text(
          'Aa',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: textColor,
              ),
        ),
      ),
    );
  }
}
