import 'package:flutter/material.dart';

import '../color.dart';

final NavigationBarThemeData navigationBarThemeData = NavigationBarThemeData(
  indicatorColor: backgroundColor.withOpacity(0),
  shadowColor: backgroundColor.withOpacity(0.8),
  height: 50,
  backgroundColor: backgroundColor.withOpacity(0),
  elevation: 0,
  iconTheme: const MaterialStatePropertyAll(
    IconThemeData(
      color: secondaryTextColor,
      size: 26,
      weight: 7.00,
    )
  ),
  labelTextStyle: const MaterialStatePropertyAll(
    TextStyle(
      fontSize: 0,
    )
  ),
  surfaceTintColor: primaryColor,
  labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
);
