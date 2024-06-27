import 'package:flutter/material.dart';
import '../../../../../config/theme/widgets/text.dart';
import '../../../../config/theme/color.dart';

class LocationListTile extends StatelessWidget {
  const LocationListTile({
    Key? key,
    required this.location,
    required this.press,
  }) : super(key: key);

  final String location;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: press,
          horizontalTitleGap: 0,
          title: Text(
            location,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium?.copyWith(
              color: onSurfaceColor,
            ),
          ),
        ),
        const Divider(
          height: 2,
          thickness: 2,
          color: surfaceColor,
        ),
      ],
    );
  }
}
