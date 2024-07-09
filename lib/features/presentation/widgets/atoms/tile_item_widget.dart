import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../config/theme/widgets/text.dart';
import 'cached_image_widget.dart';

class TileItemWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leadingIcon;
  final String? leadingImageUrl;
  final Function? onTap;
  final bool? avatar;

  const TileItemWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.leadingImageUrl,
    this.onTap,
    this.leadingIcon,
    this.avatar = false
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (onTap != null) {
            _onPressedHandler(context, onTap!);
          }
        },
        child: Row(
          children: [
            if (leadingIcon != null) leadingIcon as Widget,
            if (leadingImageUrl != null) CachedImageWidget(
              imageUrl: leadingImageUrl!,
              width: 26,
              height: 26,
              borderRadius: BorderRadius.circular(16),
            ),
            if (leadingImageUrl == null && avatar == true) ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SvgPicture.asset(
                'lib/assets/images/avatar.svg',
                height: 26,
                width: 26,
                fit: BoxFit.fitWidth,
              ),
            ),
            if (leadingIcon != null || leadingImageUrl != null || avatar == true) const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.bodyMedium,
                ),
                if (subtitle != null) Text(
                  subtitle!,
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ],
        )
    );
  }
}

void _onPressedHandler(BuildContext context, Function onPressed) {
  onPressed();
}