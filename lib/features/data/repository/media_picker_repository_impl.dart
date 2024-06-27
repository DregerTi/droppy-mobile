import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../domain/entities/media_picker_item.dart';

class MediaPickerRepositoryImpl {

  Future<List<AssetPathEntity>> fetchAlbums() async {
    try {
      await grantPermissions();
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList();
      return albums;
    } catch (e) {
      debugPrint('Error fetching albums: $e');
      return [];
    }
  }

  Future<List<MediaPickerItemEntity>> fetchMedias({
    required AssetPathEntity album,
    required int page,
  }) async {
    List<MediaPickerItemEntity> medias = [];

    try {
      final List<AssetEntity> entities =
      await album.getAssetListPaged(page: page, size: 30);

      for (AssetEntity entity in entities) {
        MediaPickerItemEntity media = MediaPickerItemEntity(
          assetEntity: entity,
          widget: FadeInImage(
            placeholder: MemoryImage(kTransparentImage),
            fit: BoxFit.cover,
            image: AssetEntityImageProvider(
              entity,
              thumbnailSize: const ThumbnailSize.square(500),
              isOriginal: false,
            ),
          ),
        );
        medias.add(media);
      }
    } catch (e) {
      debugPrint('Error fetching media: $e');
    }

    return medias;
  }

  Future<void> grantPermissions() async {
    try {
      final bool photosGranted = await Permission.photos.isGranted;

      if (!photosGranted) {
        final Map<Permission, PermissionStatus> statuses = await [
          Permission.photos,
        ].request();

        if (statuses[Permission.photos] == PermissionStatus.permanentlyDenied) {
          await openAppSettings();
        }
      }
    } catch (e) {
      debugPrint('Error granting permissions: $e');
    }
  }

}