import '../../domain/entities/content.dart';

class ContentModel extends ContentEntity {
  const ContentModel({
    String ? title,
    String ? subtitle,
    String ? picturePath,
    String ? search,
    String ? path,
  }) : super(
    title: title,
    subtitle: subtitle,
    picturePath: picturePath,
    search: search,
  );
  
  factory ContentModel.fromJson(Map<String, dynamic >map) {
    return ContentModel(
      title: map['title'],
      subtitle: map['subtitle'],
      picturePath: map['picturePath'],
      search: map['search'],
      path: map['path'],
    );
  }

  factory ContentModel.fromEntity(ContentModel entity) {
    return ContentModel(
      title: entity.title,
      subtitle: entity.subtitle,
      picturePath: entity.picturePath,
      search: entity.search,
      path: entity.path,
    );
  }
}