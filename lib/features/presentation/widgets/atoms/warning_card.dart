import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../config/theme/color.dart';
import '../../../../../config/theme/widgets/button.dart';

class WarningCard extends StatelessWidget {
  final String? icon;
  final String? message;
  final Function? onTap;

  const WarningCard({
    Key? key,
    this.icon,
    this.message,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if(icon != null && icon == 'lock') const Icon(
          Icons.lock_rounded,
          size: 50,
          color: onSurfaceColor,
        ),
        if(icon != null && icon == 'warning') const Icon(
          Icons.warning_rounded,
          size: 50,
          color: onSurfaceColor,
        ),
        if(icon != null && icon == 'error') const Icon(
          Icons.error_rounded,
          size: 50,
          color: onSurfaceColor,
        ),
        if(icon != null && icon == 'empty') const Icon(
          Icons.sentiment_dissatisfied_rounded,
          size: 50,
          color: onSurfaceColor,
        ),
        const SizedBox(height: 28),
        Text(
          message ?? '',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: onSurfaceColor,
          ),
        ),
        const SizedBox(height: 28),
        if(onTap != null) GestureDetector(
          onTap: () => onTap!(),
          child: ElevatedButton(
            onPressed: () => onTap!(),
            style: elevatedButtonThemeData.style?.copyWith(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
            ),
            child: Column(
              children: [
                if(icon != null && icon == 'lock') const Icon(
                  Icons.lock_rounded,
                  size: 50,
                  color: onSurfaceColor,
                ),
                if(icon != null && icon == 'warning') const Icon(
                  Icons.warning_rounded,
                  size: 50,
                  color: onSurfaceColor,
                ),
                if(icon != null && icon == 'error') const Icon(
                  Icons.error_rounded,
                  size: 50,
                  color: onSurfaceColor,
                ),
                if(icon != null && icon == 'empty') const Icon(
                  Icons.sentiment_dissatisfied_rounded,
                  size: 50,
                  color: onSurfaceColor,
                ),
                const SizedBox(height: 28),
                Text(
                  AppLocalizations.of(context)!.retry,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: backgroundColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}