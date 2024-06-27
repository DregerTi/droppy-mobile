import 'package:flutter/material.dart';

import '../../../../../config/theme/color.dart';
import '../../../../../config/theme/widgets/button.dart';

class ActionBar extends StatelessWidget {
  final Icon? leadingIcon;
  final String? leadingText;
  final Widget? leadingWidget;
  final Function? leadingOnPressed;
  final Icon? mainActionIcon;
  final Function? mainActionOnPressed;
  final Icon? secondaryActionIcon;
  final Function? secondaryActionOnPressed;
  final Widget? widgetAction;

  const ActionBar({
    Key? key,
    this.leadingIcon,
    this.leadingText,
    this.leadingWidget,
    this.leadingOnPressed,
    this.mainActionIcon,
    this.mainActionOnPressed,
    this.secondaryActionIcon,
    this.secondaryActionOnPressed,
    this.widgetAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          if (leadingOnPressed != null) Expanded(
            child: ElevatedButton(
              onPressed: () => _onPressedHandler(context, leadingOnPressed!),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leadingIcon != null) leadingIcon!,
                  if (leadingIcon != null) const SizedBox(width: 10),
                  if (leadingText != null) Text(leadingText!),
                  if (leadingWidget != null) leadingWidget!,
                ],
              ),
            )
          ),
          if (secondaryActionIcon != null) const SizedBox(width: 10),
          if (secondaryActionIcon != null && secondaryActionOnPressed != null) IconButton(
            onPressed: () => _onPressedHandler(context, secondaryActionOnPressed!),
            icon: secondaryActionIcon!,
            style: iconButtonThemeData.style?.copyWith(
              backgroundColor: MaterialStateProperty.all<Color>(surfaceColor),
              foregroundColor: MaterialStateProperty.all<Color>(onSurfaceColor),
            ),
          ),
          if (mainActionIcon != null) const SizedBox(width: 8),
          if (mainActionIcon != null && mainActionOnPressed != null) IconButton(
            onPressed: () => _onPressedHandler(context, mainActionOnPressed!),
            icon: mainActionIcon!,
            style: iconButtonThemeData.style?.copyWith(
              backgroundColor: MaterialStateProperty.all<Color>(surfaceColor),
              foregroundColor: MaterialStateProperty.all<Color>(onSurfaceColor),
            ),
          ),
          if(widgetAction != null) const SizedBox(width: 8),
          if(widgetAction != null) widgetAction!,
        ],
      ),
    );
  }
}

void _onPressedHandler(BuildContext context, Function onPressed) {
  onPressed();
}
