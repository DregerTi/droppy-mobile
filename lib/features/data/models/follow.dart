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
      id: map['ID'] ?? 0,
      followed: map['Followed'] != null ? UserModel.fromJson(map['Followed']) : null,
      follower: map['Follower'] != null ? UserModel.fromJson(map['Follower']) : null,
      createdAt: map['CreatedAt'] != null ? DateTime.parse(map['CreatedAt']) : null,
      updatedAt: map['UpdatedAt'] != null ? DateTime.parse(map['UpdatedAt']) : null,
      status: map['Status'] ?? 0,
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