import 'package:flutter/material.dart';

import '../color.dart';

final NavigationBarThemeData navigationBarThemeData = NavigationBarThemeData(
  indicatorColor: Colors.white.withOpacity(0),
  shadowColor: Colors.white.withOpacity(0),
  height: 50,
  backgroundColor: backgroundColor,
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
