import 'package:digiguru/app/theme/theme_colors.dart';
import 'package:digiguru/app/theme/thrmes/base_theme.dart';
import 'package:flutter/material.dart';

class GreenTheme extends BaseTheme {
  late final Color primaryColor = ThemeColor.greenColor;
  late final Color accentColor = Colors.green[400]!;
  late final Color backgroundColor = Colors.white;
  late final Color hintColor = Colors.green[600]!;
  late final Color scaffoldBackgroundColor = Colors.white;
  ThemeData data(BuildContext context) {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      hintColor: hintColor,
      canvasColor: backgroundColor,
      fontFamily: 'Open Sans',
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(),
        hintStyle: TextStyle(fontSize: hintSize, color: hintColor),
        labelStyle: TextStyle(fontSize: labelSize, color: primaryColor),
      ),
      textTheme: textTheme(primaryColor, accentColor, backgroundColor),
      appBarTheme: AppBarTheme(
          backgroundColor: primaryColor, foregroundColor: backgroundColor),
      bottomAppBarTheme: BottomAppBarThemeData(color: primaryColor),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: primaryColor,
          selectedIconTheme: IconThemeData(color: backgroundColor)),
      iconTheme: IconThemeData(
        color: primaryColor,
        size: iconSize,
        opacity: .8,
      ),

      // checkboxTheme: CheckboxThemeData(checkColor: MaterialStateProperty(backgroundColor)),

      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(colors: [
              const Color.fromARGB(255, 122, 237, 132),
              backgroundColor
            ])),
        showDuration: Duration(seconds: 2),
        waitDuration: Duration(seconds: 1),
        preferBelow: false,
        textStyle:
            TextStyle(fontSize: tooltipFontSize, fontStyle: FontStyle.normal),
        padding: EdgeInsets.all(8.0),
      ),
      //dialog
      dialogTheme: DialogThemeData(
        contentTextStyle: TextStyle(
            fontSize: 15, fontWeight: FontWeight.normal, color: primaryColor),
        titleTextStyle: TextStyle(
            fontSize: 17, fontWeight: FontWeight.bold, color: primaryColor),
      ),
      colorScheme: ColorScheme(
          surface: backgroundColor,
          brightness: Brightness.light,
          primary: primaryColor,
          onPrimary: backgroundColor,
          secondary: accentColor,
          onSecondary: backgroundColor,
          error: Colors.red,
          onError: Colors.white,
          onSurface: primaryColor),
    );
  }
}
