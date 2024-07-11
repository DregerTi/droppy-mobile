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
        const SizedBox(height: 34),
        Text(
          message ?? '',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: onSurfaceColor,
          ),
        ),
        const SizedBox(height: 14),
        if(onTap != null) GestureDetector(
          onTap: () => onTap!(),
          child: ElevatedButton(
            onPressed: () => onTap!(),
            style: elevatedButtonThemeData.style?.copyWith(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
            ),
            child: Text(
              AppLocalizations.of(context)!.retry,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: backgroundColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}