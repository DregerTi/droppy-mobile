import 'package:flutter/material.dart';

import '../color.dart';

const InputDecorationTheme inputDecorationThemeData = InputDecorationTheme(
  fillColor: surfaceColor,
  filled: true,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    borderSide: BorderSide.none,
  ),
  floatingLabelBehavior: FloatingLabelBehavior.never,
  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  labelStyle: TextStyle(
    color: textColor,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  ),
  floatingLabelStyle: TextStyle(
    color: textColor,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  ),
  helperStyle: TextStyle(
    color: onSurfaceColor,
    fontSize: 10,
  ),
  hintStyle: TextStyle(
    color: onSurfaceColor,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  ),
  errorStyle: TextStyle(
    color: errorColor,
    fontSize: 10,
  ),
  iconColor: primaryColor,
  prefixStyle: TextStyle(
    color: primaryColor,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  ),
  prefixIconColor: primaryColor,
  suffixStyle: TextStyle(
    color: primaryColor,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  ),
  suffixIconColor: primaryColor,
  counterStyle: TextStyle(
    color: onSurfaceColor,
    fontSize: 12,
  ),
  /*


  bool isCollapsed = false,
  Color? focusColor,
  Color? hoverColor,
  InputBorder? errorBorder,
  InputBorder? focusedBorder,
  InputBorder? focusedErrorBorder,
  InputBorder? disabledBorder,
  InputBorder? enabledBorder,
  bool alignLabelWithHint = false,
  constraints,*/
);