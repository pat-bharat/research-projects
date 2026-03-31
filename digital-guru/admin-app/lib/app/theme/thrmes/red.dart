import 'package:digiguru/app/theme/theme_colors.dart';
import 'package:digiguru/app/theme/thrmes/base_theme.dart';
import 'package:flutter/material.dart';

class RedTheme extends BaseTheme {
  var primaryColor = ThemeColor.redColor;
  var accentColor = Colors.red[600];
  var backgroundColor = Colors.white;
  var hintColor = Colors.red[600];
  var scaffoldBackgroundColor = Colors.white;
  ThemeData data(BuildContext context) {
    return ThemeData(
      primaryColor: primaryColor,
      backgroundColor: backgroundColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      accentColor: accentColor,
      buttonColor: primaryColor,
      hintColor: hintColor,
      canvasColor: backgroundColor,
      fontFamily: 'Open Sans',
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(),
        hintStyle: TextStyle(fontSize: hintSize, color: hintColor),
        labelStyle: TextStyle(fontSize: labelSize, color: primaryColor),
      ),
      textTheme: textTheme(primaryColor, accentColor, backgroundColor),
      appBarTheme:
          AppBarTheme(color: primaryColor, foregroundColor: backgroundColor),
      bottomAppBarTheme: BottomAppBarTheme(color: primaryColor),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: primaryColor,
          selectedIconTheme: IconThemeData(color: backgroundColor)),
      iconTheme: IconThemeData(
        color: primaryColor,
        size: iconSize,
        opacity: .8,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: primaryColor,
          onPrimary: Colors.white,
        ),
      ),
      // checkboxTheme: CheckboxThemeData(checkColor: MaterialStateProperty(backgroundColor)),
      // buttonTheme: ButtonTheme(buttonColor: primaryColor, child: null,),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient:
                LinearGradient(colors: [Colors.green[50], backgroundColor])),
        showDuration: Duration(seconds: 2),
        waitDuration: Duration(seconds: 1),
        preferBelow: false,
        textStyle:
            TextStyle(fontSize: tooltipFontSize, fontStyle: FontStyle.normal),
        padding: EdgeInsets.all(8.0),
      ),
      //dialog
      dialogTheme: DialogTheme(
        contentTextStyle: TextStyle(
            fontSize: 15, fontWeight: FontWeight.normal, color: primaryColor),
        titleTextStyle: TextStyle(
            fontSize: 17, fontWeight: FontWeight.bold, color: primaryColor),
      ),
    );
  }
}
