
import '../../domain/entities/content_type.dart';

class ContentTypeModel extends ContentTypeEntity {
  const ContentTypeModel({
    int ? id,
    String ? name,
    String ? description,
    String ? picturePath,
  }) : super(
    id: id,
    name: name,
    description: description,
    picturePath: picturePath
  );
  
  factory ContentTypeModel.fromJson(Map<String, dynamic >map) {
    return ContentTypeModel(
      id: map['id'] ?? "",
      name: map['name'] ?? "",
      description: map['description'] ?? "",
      picturePath: map['picturePath'] ?? "",
    );
  }

  factory ContentTypeModel.fromEntity(ContentTypeModel entity) {
    return ContentTypeModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      picturePath: entity.picturePath,
    );
  }
}