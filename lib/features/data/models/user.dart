import 'package:droppy/features/data/models/drop.dart';
import 'package:droppy/features/data/models/group.dart';
import '../../domain/entities/user.dart';
import 'follow.dart';

class UserModel extends UserEntity {
  const UserModel({
    int ? id,
    String ? email,
    String ? avatar,
    List ? roles,
    String ? username,
    String ? provider,
    String ? phoneNumber,
    String ? bio,
    List<dynamic> ? origin,
    int ? totalFollowers,
    int ? totalFollowed,
    DropModel ? lastDrop,
    List<DropModel> ? pinnedDrops,
    List<GroupModel> ? groups,
    int? totalDrops,
    FollowModel ? currentFollow,
    bool ? isPrivate,
    String ? createdAt
  }) : super(
    id: id,
    email: email,
    avatar: avatar,
    roles: roles,
    username: username,
    provider: provider,
    phoneNumber: phoneNumber,
    bio: bio,
    origin: origin,
    totalFollowers: totalFollowers,
    totalFollowed: totalFollowed,
    lastDrop: lastDrop,
    pinnedDrops: pinnedDrops,
    groups: groups,
    totalDrops: totalDrops,
    currentFollow: currentFollow,
    isPrivate: isPrivate,
    createdAt: createdAt
  );
  
  factory UserModel.fromJson(Map<String, dynamic >map) {
    return UserModel(
      id: map['ID'] ?? "",
      email: map['Email'] ?? "",
      avatar: map['Avatar'],
      roles: map['roles'] ?? [],
      username: map['Username'] ?? "",
      provider: map['Provider'] ?? "",
      phoneNumber: map['PhoneNumber'] ?? "",
      bio: map['Bio'] ?? "",
      origin: map['origin'] ?? [],
      totalFollowers: map['TotalFollowers'] ?? 0,
      totalFollowed: map['TotalFollowed'] ?? 0,
      lastDrop: map['LastDrop'] != null ? DropModel.fromJson(map['LastDrop']) : null,
      pinnedDrops: map['PinnedDrops'] != null ? (map['PinnedDrops'] as List).map((e) => DropModel.fromJson(e)).toList() : [],
      groups: map['Groups'] != null ? (map['Groups'] as List).map((e) => GroupModel.fromJson(e)).toList() : [],
      totalDrops: map['TotalDrops'] ?? 0,
      currentFollow: map['CurrentFollow'] != null ? FollowModel.fromJson(map['CurrentFollow']) : null,
      isPrivate: map['IsPrivate'] ?? false,
      createdAt: map['CreatedAt'] ?? "18/07/2021"
    );
  }

  factory UserModel.fromEntity(UserModel entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      avatar: entity.avatar,
      roles: entity.roles,
      username: entity.username,
      provider: entity.provider,
      phoneNumber: entity.phoneNumber,
      bio: entity.bio,
      origin: entity.origin,
      totalFollowers: entity.totalFollowers,
      totalFollowed: entity.totalFollowed,
      lastDrop: entity.lastDrop,
      pinnedDrops: entity.pinnedDrops,
      groups: entity.groups,
      totalDrops: entity.totalDrops,
      currentFollow: entity.currentFollow,
      isPrivate: entity.isPrivate,
      createdAt: entity.createdAt
    );
  }
}