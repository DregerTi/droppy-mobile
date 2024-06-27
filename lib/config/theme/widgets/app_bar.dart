import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../color.dart';


const AppBarTheme appBarThemeData = AppBarTheme(
  backgroundColor: backgroundColor,
  foregroundColor: textColor,
  elevation: 0,
  iconTheme: IconThemeData(
    color: textColor,
    size: 26,
    weight: 7.00,
  ),
  surfaceTintColor: textColor,
  centerTitle: false,
  actionsIconTheme: IconThemeData(
    color: textColor,
    size: 26,
    weight: 7.00,
  ),
  systemOverlayStyle: SystemUiOverlayStyle(
    statusBarColor: primaryColor,
    statusBarIconBrightness: Brightness.dark,
  ),
  toolbarHeight: 60,
  titleSpacing: 20,
);
