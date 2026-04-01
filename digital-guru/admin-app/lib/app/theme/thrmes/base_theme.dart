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
      bodyLarge: TextStyle(
          fontSize: size17, fontWeight: FontWeight.normal, color: primaryColor),
      bodyMedium: TextStyle(
          fontSize: size15, fontWeight: FontWeight.normal, color: primaryColor),
      bodySmall: TextStyle(
          fontSize: size15, fontWeight: FontWeight.normal, color: primaryColor),
      labelLarge: TextStyle(
          fontSize: size15, fontWeight: FontWeight.normal, color: button),
      titleLarge: TextStyle(
          fontSize: size20, fontWeight: FontWeight.bold, color: primaryColor),
      titleMedium: TextStyle(
          fontSize: size17, fontWeight: FontWeight.bold, color: primaryColor),
      displayLarge: TextStyle(
          fontSize: size25, fontWeight: FontWeight.bold, color: accentColor),
      displayMedium: TextStyle(
          fontSize: size20, fontWeight: FontWeight.bold, color: primaryColor),
      displaySmall: TextStyle(
          fontSize: size17, fontWeight: FontWeight.normal, color: primaryColor),
      headlineMedium: TextStyle(
          fontSize: size15, fontWeight: FontWeight.normal, color: primaryColor),
      headlineSmall: TextStyle(
          fontSize: size12, fontWeight: FontWeight.normal, color: primaryColor),
      titleSmall: TextStyle(
          fontSize: size10, fontStyle: FontStyle.normal, color: primaryColor),
    );
  }
}
