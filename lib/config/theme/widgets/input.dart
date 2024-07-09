import 'package:droppy/config/theme/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

import '../color.dart';

InputDecoration inputDecoration(
  String name,
  String error,
  Widget? suffixIcon,
) =>
    InputDecoration(
      fillColor: surfaceColor,
      filled: true,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(16),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: errorColor,
          width: 2,
        ),
      ),
      floatingLabelStyle: textTheme.labelMedium?.copyWith(
        color: error.isNotEmpty ? errorColor : secondaryTextColor,
      ),
      labelText:
          error.isNotEmpty ? error : toBeginningOfSentenceCase(name) as String,
      labelStyle: textTheme.labelMedium?.copyWith(
            color: error.isNotEmpty ? errorColor : null,
          ),
      hintText:
          error.isNotEmpty ? toBeginningOfSentenceCase(name) as String : null,
      hintStyle: textTheme.labelMedium?.copyWith(
            color:
                error.isNotEmpty ? errorColor : secondaryTextColor,
          ),
      errorStyle: textTheme.labelSmall,
    ); 
