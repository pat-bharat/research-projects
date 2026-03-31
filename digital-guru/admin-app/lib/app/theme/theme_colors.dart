import 'package:flutter/material.dart';

class ThemeColor {
  final String name;

  /// Backend server understands this
  final Color value;

  ThemeColor._(this.name, this.value);
  static Color redColor = Colors.red[900];
  static Color greenColor = Colors.green[800];
  static Color blueColor = Colors.blue[800];

  /// Default behavior
  static ThemeColor green = ThemeColor._('Green', Colors.green[800]);
  static ThemeColor red = ThemeColor._('Red', redColor);
  static ThemeColor blue = ThemeColor._('Red', redColor);

  /// All available server behaviors.
  static List<ThemeColor> all = [
    green,
    blue,
    red,
  ];
}
