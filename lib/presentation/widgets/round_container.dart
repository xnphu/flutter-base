import 'package:flutter/material.dart';

class RoundContainer extends StatelessWidget {
  final Widget child;
  final double topLeftRadius;
  final double topRightRadius;
  final double bottomLeftRadius;
  final double bottomRightRadius;
  final double? allRadius;
  final Color? color;
  final BoxShadow? shadow;
  final double? height;
  final double? width;
  final Color? borderColor;
  final double? borderWidth;

  RoundContainer({
    required this.child,
    this.topLeftRadius = 0,
    this.topRightRadius = 0,
    this.bottomLeftRadius = 0,
    this.bottomRightRadius = 0,
    this.color,
    this.shadow,
    this.allRadius,
    this.height,
    this.width,
    this.borderColor = Colors.transparent,
    this.borderWidth = 1,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.only(
        topLeft: Radius.circular(allRadius ?? topLeftRadius),
        topRight: Radius.circular(allRadius ?? topRightRadius),
        bottomLeft: Radius.circular(allRadius ?? bottomLeftRadius),
        bottomRight: Radius.circular(allRadius ?? bottomRightRadius));
    return Container(
      height: height,
      width: width,
      child: ClipRRect(
        child: child,
        borderRadius: radius,
      ),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 0),
            ),
          ],
          color: color ?? Colors.white,
          borderRadius: radius,
          border: borderColor != null
              ? Border.all(color: borderColor!, width: this.borderWidth ?? 1)
              : null),
    );
  }
}
