import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../../../config/theme/color.dart';
import '../../../domain/entities/media_picker_item.dart';
import 'media_item.dart';

class MediasGrid extends StatefulWidget {
  final List<MediaPickerItemEntity> medias;
  final List<MediaPickerItemEntity> selectedMedias;
  final Function(MediaPickerItemEntity) selectMedia;
  final ScrollController scrollController;

  const MediasGrid({
    super.key,
    required this.medias,
    required this.selectedMedias,
    required this.selectMedia,
    required this.scrollController,
  });

  @override
  State<MediasGrid> createState() => _MediasGridState();
}

class _MediasGridState extends State<MediasGrid> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - kBottomNavigationBarHeight - 160,
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      child: GridView.builder(
        controller: widget.scrollController,
        physics: const BouncingScrollPhysics(),
        itemCount: widget.medias.length + 1,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 3,
          crossAxisSpacing: 3,
        ),
        itemBuilder: (context, index) {
          if (index == 0) {
            return GestureDetector(
              onTap: () {
                _pickImageFromCamera();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      color: onSurfaceColor,
                      size: 42,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return MediaItem(
              media: widget.medias[index - 1],
              isSelected: widget.selectedMedias.any((element) =>
              element.assetEntity?.id == widget.medias[index - 1].assetEntity?.id),
              selectMedia: widget.selectMedia,
            );
          }
        }
      ),
    );
  }

  Future _pickImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        widget.selectedMedias.add(MediaPickerItemEntity(
          assetEntity: AssetEntity(
            id: pickedFile.path,
            typeInt: 0,
            width: 0,
            height: 0,
            duration: 0,
            title: pickedFile.name,
          ),
          widget: Image.file(File(pickedFile.path)),
        ));
      });
    }
  }
}
