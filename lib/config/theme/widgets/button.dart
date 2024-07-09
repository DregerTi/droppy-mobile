import 'package:flutter/material.dart';

import '../color.dart';

final ElevatedButtonThemeData elevatedButtonThemeData = ElevatedButtonThemeData(
  style: ButtonStyle(
    backgroundColor: WidgetStateProperty.all<Color>(onPrimaryColor),
    foregroundColor: MaterialStateProperty.all<Color>(textColor),
    overlayColor: MaterialStateProperty.all<Color>(Colors.black.withOpacity(0.09)),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  ),
);


final OutlinedButtonThemeData outlinedButtonThemeData = OutlinedButtonThemeData(
  style: ButtonStyle(
    overlayColor: MaterialStateProperty.all(surfaceColor),
    foregroundColor: MaterialStateProperty.all(onSurfaceColor),
    textStyle: MaterialStateProperty.all(
      const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
    ),
    side: MaterialStateProperty.all(const BorderSide(width: 3, color: onSurfaceColor)),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  ),
);

final IconButtonThemeData iconButtonThemeData = IconButtonThemeData(
  style: ButtonStyle(
    foregroundColor: MaterialStateProperty.all(onSurfaceColor),
    backgroundColor: MaterialStateProperty.all(surfaceColor),
    iconSize: MaterialStateProperty.all(20),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),
  ),
);