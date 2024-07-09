import 'package:droppy/config/theme/widgets/text.dart';
import 'package:flutter/material.dart';

import '../color.dart';

final ChipThemeData chipThemeData = ChipThemeData(
  backgroundColor: surfaceColor,
  disabledColor: surfaceColor,
  selectedColor: textColor,
  secondarySelectedColor: onPrimaryColor,
  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
  labelStyle: textTheme.labelSmall?.copyWith(
    color: textColor,
  ),
  secondaryLabelStyle: textTheme.labelSmall?.copyWith(
    color: onPrimaryColor,
  ),
  shape: RoundedRectangleBorder(
    side: const BorderSide(
      style: BorderStyle.none,
    ),
    borderRadius: BorderRadius.circular(16),
  ),
  brightness: Brightness.light,
  elevation: 0,
  pressElevation: 0.8,
  shadowColor: null,
  selectedShadowColor: textColor,
  
);