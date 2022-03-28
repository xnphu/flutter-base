import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressHud extends StatelessWidget {
  final bool inAsyncCall;
  final double opacity;
  final Color color;
  final Widget progressIndicator;
  final Offset? offset;
  final bool dismissible;
  final Widget child;

  ProgressHud({
    Key? key,
    this.inAsyncCall = false,
    this.opacity = 0.3,
    this.color = Colors.transparent,
    this.progressIndicator = const CircularProgressIndicator(
      valueColor:AlwaysStoppedAnimation<Color>(Colors.white),
    ),
    // this.progressIndicator = const CupertinoActivityIndicator(
    //   radius: 20,
    // ),
    this.offset,
    this.dismissible = false,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    widgetList.add(child);
    if (inAsyncCall) {
      Widget layOutProgressIndicator;
      if (offset == null) {
        layOutProgressIndicator = Center(child: progressIndicator);
      } else {
        layOutProgressIndicator = Positioned(
          child: progressIndicator,
          left: offset?.dx ?? 0,
          top: offset?.dy ?? 0,
        );
      }
      final modal = [
        new Opacity(
          child: new ModalBarrier(dismissible: dismissible, color: color),
          opacity: opacity,
        ),
        layOutProgressIndicator
      ];
      widgetList += modal;
    }
    return new Stack(
      children: widgetList,
    );
  }
}
