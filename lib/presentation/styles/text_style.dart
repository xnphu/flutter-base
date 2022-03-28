import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_fonts.dart';

TextStyle getTextStyle(
    {double fontSize = 15,
    Color color = Colors.white,
    FontWeight fontWeight = FontWeight.w400,
    fontStyle: FontStyle.normal,
    String fontFamily = AppFonts.roboto,
    double lineHeight = 1,
    TextDecoration? decoration}) {
  return TextStyle(
      decoration: decoration,
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontFamily: fontFamily,
      height: lineHeight);
}

TextStyle getHintTextStyle(
    {Color hintColor = const Color.fromARGB(50, 255, 255, 255),
    double fontSize = 15,
    FontWeight fontWeight = FontWeight.w400,
    String fontFamily = AppFonts.roboto,
    fontStyle: FontStyle.normal}) {
  return TextStyle(
      color: hintColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      fontStyle: fontStyle);
}
