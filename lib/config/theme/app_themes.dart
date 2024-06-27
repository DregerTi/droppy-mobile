import 'package:droppy/config/theme/widgets/app_bar.dart';
import 'package:droppy/config/theme/widgets/button.dart';
import 'package:droppy/config/theme/widgets/chip.dart';
import 'package:droppy/config/theme/widgets/input_decoration.dart';
import 'package:droppy/config/theme/widgets/navigation_bar.dart';
import 'package:droppy/config/theme/widgets/snack_bar.dart';
import 'package:droppy/config/theme/widgets/text.dart';
import 'package:flutter/material.dart';

import 'color.dart';


ThemeData theme(){
  return ThemeData(
    snackBarTheme: snackBarThemeData,
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: appBarThemeData,
    chipTheme: chipThemeData,
    elevatedButtonTheme: elevatedButtonThemeData,
    outlinedButtonTheme: outlinedButtonThemeData,
    iconButtonTheme: iconButtonThemeData,
    navigationBarTheme: navigationBarThemeData,
    textTheme: textTheme,
    inputDecorationTheme: inputDecorationThemeData,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      error: errorColor,
      surface: surfaceColor,
      background: backgroundColor,
      onPrimary: onPrimaryColor,
      onSecondary: onSecondaryColor,
      onError: onErrorColor,
      onSurface: onSurfaceColor,
      onBackground: onBackgroundColor,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
  );
}
