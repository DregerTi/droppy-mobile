import 'package:flutter/material.dart';
import '../../../../config/theme/color.dart';
import '../../../domain/entities/media_picker_item.dart';

class MediaItem extends StatelessWidget {
  final MediaPickerItemEntity media;
  final bool isSelected;
  final Function selectMedia;

  const MediaItem({
    required this.media,
    required this.isSelected,
    required this.selectMedia,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectMedia(media),
      child: Stack(
        children: [
          _buildMediaWidget(),
          if (isSelected) _buildIsSelectedOverlay(),
        ],
      ),
    );
  }

  Widget _buildMediaWidget() {
    return Positioned.fill(
      child: Padding(
        padding: EdgeInsets.all(isSelected ? 10.0 : 0.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: media.widget,
        ),
      ),
    );
  }

  Widget _buildIsSelectedOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: backgroundColor.withOpacity(0.4),
        ),
        child: const Center(
          child: Icon(
            Icons.check_circle_rounded,
            color: primaryColor,
            size: 30,
          ),
        ),
      ),
    );
  }
}
