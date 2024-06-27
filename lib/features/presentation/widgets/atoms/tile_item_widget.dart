import 'package:flutter/material.dart';
import '../../../../../config/theme/widgets/text.dart';
import 'cached_image_widget.dart';

class TileItemWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leadingIcon;
  final String? leadingImageUrl;
  final Function? onTap;

  const TileItemWidget({
    Key? key,
    required this.title,
    this.subtitle,
    this.leadingImageUrl,
    this.onTap,
    this.leadingIcon,
  }) : super(key: key);

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
            borderRadius: BorderRadius.circular(26),
          ),
          if (leadingIcon != null || leadingImageUrl != null) const SizedBox(width: 16),
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