import 'package:digiguru/app/theme/theme_colors.dart';
import 'package:digiguru/app/theme/thrmes/blue.dart';
import 'package:digiguru/app/theme/thrmes/green.dart';
import 'package:digiguru/app/theme/thrmes/red.dart';
import 'package:flutter/material.dart';

class ThemeService {
  ThemeData getTheme(BuildContext context, ThemeColor color) {
    switch (color.name) {
      case "Green":
        return GreenTheme().data(context);
      case "Red":
        return RedTheme().data(context);
      default:
        return BlueTheme().data(context);
    }
  }
}
