import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

// Define a class to hold media assets and corresponding widgets
class MediaPickerItemEntity {
  // Represents a media asset managed by photo_manager
  final AssetEntity? assetEntity;
  // Represents a Flutter widget associated with the asset
  final Widget widget;
  MediaPickerItemEntity({
    // Initialize with a required AssetEntity
    this.assetEntity,
    // Initialize with a required Widget
    required this.widget,
  });
}