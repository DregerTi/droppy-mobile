import 'package:droppy/features/data/models/drop.dart';
import 'package:droppy/features/data/models/user.dart';
import '../../domain/entities/like.dart';

class LikeModel extends LikeEntity {
  const LikeModel({
    int ? id,
    DropModel ? drop,
    String ? dropIri,
    UserModel ? user,
  }) : super(
    id: id,
    drop: drop,
    dropIri: dropIri,
    user: user,
  );
  
  factory LikeModel.fromJson(Map<String, dynamic >map) {

    return LikeModel(
      id: map['id'] ?? "",
      drop: map['drop'] != null && map['drop'] is !String ? DropModel.fromJson(map['drop']) : null,
      dropIri: map['drop'] != null && map['drop'] is String ? map['drop'] : null,
      user: map['user'] != null ? UserModel.fromJson(map['user']) : null,
    );
  }

  factory LikeModel.fromEntity(LikeModel entity) {
    return LikeModel(
      id: entity.id,
      drop: entity.drop,
      dropIri: entity.dropIri,
      user: entity.user,
    );
  }
}