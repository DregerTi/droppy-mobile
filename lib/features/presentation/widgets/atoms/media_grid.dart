import 'package:flutter/material.dart';
import '../../../domain/entities/media_picker_item.dart';
import 'media_item.dart';

class MediaGrid extends StatelessWidget {
  final List<MediaPickerItemEntity> medias;
  final List<MediaPickerItemEntity> selectedMedias;
  final Function(MediaPickerItemEntity) selectMedia;
  final ScrollController scrollController;
  const MediaGrid(
      {super.key,
      required this.medias,
      required this.selectedMedias,
      required this.selectMedia,
      required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      itemCount: medias.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 3,
        crossAxisSpacing: 3,
      ),
      itemBuilder: (context, index) {
        return MediaItem(
          media: medias[index],
          isSelected: selectedMedias.any((element) =>
              element.assetEntity?.id == medias[index].assetEntity?.id),
          selectMedia: selectMedia,
        );
      },
    );
  }
}
