import 'package:flutter/material.dart';

class ThemeColor {
  final String name;

  /// Backend server understands this
  final Color value;

  ThemeColor._(this.name, this.value);
  static Color redColor = const Color.fromARGB(255, 240, 163, 163);
  static Color greenColor = const Color.fromARGB(255, 161, 230, 165);
  static Color blueColor = const Color.fromARGB(255, 154, 187, 223);

  /// Default behavior
  static ThemeColor green = ThemeColor._('Green', const Color.fromARGB(255, 172, 236, 175));
  static ThemeColor red = ThemeColor._('Red', redColor);
  static ThemeColor blue = ThemeColor._('Red', redColor);

  /// All available server behaviors.
  static List<ThemeColor> all = [
    green,
    blue,
    red,
  ];
}
