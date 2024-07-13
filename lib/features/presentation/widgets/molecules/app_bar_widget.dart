import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../config/theme/widgets/button.dart';
import '../../../../../config/theme/widgets/text.dart';

class AppBarWidget extends StatelessWidget {
  final Icon? leadingIcon;
  final Function? leadingOnPressed;
  final String? title;
  final Icon? mainActionIcon;
  final Function? mainActionOnPressed;
  final Icon? secondaryActionIcon;
  final Function? secondaryActionOnPressed;
  final Widget? actionWidget;

  const AppBarWidget({
    super.key,
    this.leadingIcon,
    this.leadingOnPressed,
    this.title,
    this.mainActionIcon,
    this.mainActionOnPressed,
    this.secondaryActionIcon,
    this.secondaryActionOnPressed,
    this.actionWidget,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (leadingIcon != null) IconButton(
                    icon: leadingIcon!,
                    onPressed: () => _onPressedHandler(
                      context,
                      (leadingOnPressed != null) ?
                        leadingOnPressed! :
                        () {context.pop();}
                    ),
                    style: iconButtonThemeData.style?.copyWith(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  if (title != null) Text(
                      title!,
                      style: textTheme.headlineMedium,
                  ),
                ],
              ),
              Row(
                  children: [
                    if (secondaryActionIcon != null && secondaryActionOnPressed != null) IconButton(
                      icon: secondaryActionIcon!,
                      onPressed: () => _onPressedHandler(context, secondaryActionOnPressed!()),
                      style: iconButtonThemeData.style?.copyWith(
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    if (secondaryActionIcon != null && mainActionIcon != null) const SizedBox(width: 8),
                    if (mainActionIcon != null && mainActionOnPressed != null) IconButton(
                      icon: mainActionIcon!,
                      onPressed: () => _onPressedHandler(context, mainActionOnPressed!),
                      style: iconButtonThemeData.style?.copyWith(
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    if (actionWidget != null) const SizedBox(width: 8),
                    if (actionWidget != null) actionWidget!,
                  ]
              )
            ],
          ),
        )
    );
  }
}

void _onPressedHandler(BuildContext context, Function onPressed) {
  onPressed();
}
