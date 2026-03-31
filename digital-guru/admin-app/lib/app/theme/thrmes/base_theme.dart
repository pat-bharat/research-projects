import 'package:flutter/material.dart';

class BaseTheme {
  //font sizes
  double hintSize = 15;
  double labelSize = 17;
  double iconSize = 30; // used in bottom nav bar
  double tooltipFontSize = 13;
  //textfonts
  double size25 = 25;
  double size20 = 20;
  double size17 = 17;
  double size15 = 15;
  double size12 = 12;
  double size10 = 10;
  textTheme(Color primaryColor, Color accentColor, Color button) {
    return TextTheme(
      bodyText1: TextStyle(
          fontSize: size17, fontWeight: FontWeight.normal, color: primaryColor),
      bodyText2: TextStyle(
          fontSize: size15, fontWeight: FontWeight.normal, color: primaryColor),
      caption: TextStyle(
          fontSize: size15, fontWeight: FontWeight.normal, color: primaryColor),
      button: TextStyle(
          fontSize: size15, fontWeight: FontWeight.normal, color: button),
      subtitle1: TextStyle(
          fontSize: size20, fontWeight: FontWeight.bold, color: primaryColor),
      subtitle2: TextStyle(
          fontSize: size17, fontWeight: FontWeight.bold, color: primaryColor),
      headline1: TextStyle(
          fontSize: size25, fontWeight: FontWeight.bold, color: accentColor),
      headline2: TextStyle(
          fontSize: size20, fontWeight: FontWeight.bold, color: primaryColor),
      headline3: TextStyle(
          fontSize: size17, fontWeight: FontWeight.normal, color: primaryColor),
      headline4: TextStyle(
          fontSize: size15, fontWeight: FontWeight.normal, color: primaryColor),
      headline5: TextStyle(
          fontSize: size12, fontWeight: FontWeight.normal, color: primaryColor),
      headline6: TextStyle(
          fontSize: size10, fontStyle: FontStyle.normal, color: primaryColor),
    );
  }
}
