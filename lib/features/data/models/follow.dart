import 'package:droppy/features/data/models/user.dart';
import '../../domain/entities/follow.dart';

class FollowModel extends FollowEntity {
  const FollowModel({
    int ? id,
    UserModel ? followed,
    UserModel ? follower,
    DateTime ? createdAt,
    DateTime ? updatedAt,
    int ? status
  }) : super(
    id: id,
    followed: followed,
    follower: follower,
    createdAt: createdAt,
    updatedAt: updatedAt,
    status: status
  );
  
  factory FollowModel.fromJson(Map<String, dynamic >map) {

    return FollowModel(
      id: map['id'] ?? 0,
      followed: map['followed'] != null ? UserModel.fromJson(map['followed']) : null,
      follower: map['follower'] != null ? UserModel.fromJson(map['follower']) : null,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      status: map['status'] ?? 0,
    );
  }

  factory FollowModel.fromEntity(FollowModel entity) {
    return FollowModel(
      id: entity.id,
      followed: entity.followed,
      follower: entity.follower,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      status: entity.status
    );
  }
}