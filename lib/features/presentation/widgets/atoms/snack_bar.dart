import 'package:flutter/material.dart';
import '../../../../../config/theme/color.dart';
import '../../../../config/theme/widgets/text.dart';

void snackBarWidget({
  required String message,
  required BuildContext context,
  bool? isIcon = true,
  String? type
}) {
  Color backgroundColor = secondaryColor;
  IconData icon = Icons.check_circle;

  switch (type) {
    case 'error':
      backgroundColor = errorColor;
      icon = Icons.error;
      break;
    case 'warning':
      backgroundColor = warningColor;
      icon = Icons.warning;
      break;
    default:
      backgroundColor = secondaryColor;
      icon = Icons.check_circle;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      animation: AnimationController(vsync: Scaffold.of(context)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      backgroundColor: backgroundColor,
      content: Expanded(
        child: Row(
          children: [
            if (isIcon != null)
              Icon(
                icon,
                color: Colors.white,
              ),
            if (isIcon != null) const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

}