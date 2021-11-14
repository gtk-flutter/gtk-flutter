import 'package:flutter/material.dart';
import 'package:gtk/src/utils/colors.dart';

class GtkContainer extends StatelessWidget {
  const GtkContainer({
    Key? key,
    required this.child,
    this.width = 580,
    this.borderWidth = 2,
    this.padding = EdgeInsets.zero,
    this.margin = const EdgeInsets.all(14),
  }) : super(key: key);

  final Widget child;
  final double? width;
  final double borderWidth;
  final EdgeInsets padding;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.light
              ? borderLight
              : borderDark,
          width: borderWidth,
        ),
      ),
      child: child,
    );
  }
}
