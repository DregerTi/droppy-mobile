import 'package:flutter/material.dart';

import '../color.dart';

final ElevatedButtonThemeData elevatedButtonThemeData = ElevatedButtonThemeData(
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
    foregroundColor: MaterialStateProperty.all<Color>(backgroundColor),
    overlayColor: MaterialStateProperty.all<Color>(Colors.black.withOpacity(0.08)),
    shadowColor: MaterialStateProperty.all<Color>(Colors.black.withOpacity(0)),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
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
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    ),
    side: MaterialStateProperty.all(const BorderSide(width: 3, color: onSurfaceColor)),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
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
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
  ),
);