import 'package:base/presentation/styles/index.dart';
import 'package:flutter/material.dart';

class ErrorMessageWidget extends StatelessWidget {
  final String error;

  ErrorMessageWidget(this.error);

  @override
  Widget build(BuildContext context) {
    return Text(error,
        maxLines: 10,
        style: getTextStyle(
            color: AppColors.colorHelper,
            fontSize: 11,
            fontWeight: FontWeight.normal));
  }
}
