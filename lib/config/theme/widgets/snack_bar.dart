import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../color.dart';


final SnackBarThemeData snackBarThemeData = SnackBarThemeData(
  backgroundColor: secondaryColor,
  contentTextStyle: const TextStyle(
    color: backgroundColor,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),
  actionTextColor: backgroundColor,
  elevation: 0,
  behavior: SnackBarBehavior.floating,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  ),
);
