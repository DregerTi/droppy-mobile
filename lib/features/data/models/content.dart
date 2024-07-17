import '../../domain/entities/content.dart';

class ContentModel extends ContentEntity {
  const ContentModel({
    String ? title,
    String ? subtitle,
    String ? picturePath,
    String ? search,
    String ? path,
    String ? content,
  }) : super(
    title: title,
    subtitle: subtitle,
    picturePath: picturePath,
    search: search,
    content: content,
  );
  
  factory ContentModel.fromJson(Map<String, dynamic >map) {
    return ContentModel(
      title: map['Title'],
      subtitle: map['Subtitle'],
      picturePath: map['PicturePath'],
      search: map['Search'],
      path: map['Path'],
      content: map['Content'],
    );
  }

  factory ContentModel.fromEntity(ContentModel entity) {
    return ContentModel(
      title: entity.title,
      subtitle: entity.subtitle,
      picturePath: entity.picturePath,
      search: entity.search,
      path: entity.path,
      content: entity.content,
    );
  }
}