import 'package:droppy/features/data/models/drop.dart';
import 'package:droppy/features/data/models/group_member.dart';
import 'package:droppy/features/data/models/user.dart';
import '../../domain/entities/group.dart';

class GroupModel extends GroupEntity {
  const GroupModel({
    int ? id,
    String ? name,
    String ? description,
    bool ? isPrivate,
    String ? picturePath,
    UserModel ? createdBy,
    List<DropModel> ? drops,
    DateTime ? createdAt,
    DateTime ? updatedAt,
    List<GroupMemberModel> ? groupMembers,
    int? totalDrops,
  }) : super(
    id: id,
    name: name,
    description: description,
    isPrivate: isPrivate,
    picturePath: picturePath,
    createdBy: createdBy,
    drops: drops,
    createdAt: createdAt,
    updatedAt: updatedAt,
    groupMembers: groupMembers,
    totalDrops: totalDrops,
  );
  
  factory GroupModel.fromJson(Map<String, dynamic >map) {
    return GroupModel(
      id: map['ID'] ?? "",
      name: map['Name'] ?? "",
      description: map['Description'],
      picturePath: map['PicturePath'],
      isPrivate: map['IsPrivate'] ?? false,
      drops: (map['GroupDrops'] != null
          && map['GroupDrops'].length > 0 ?
        (map['GroupDrops'] as List<dynamic>)
          .map((drop) => DropModel.fromJson(drop))
          .toList()
        : []
      ),
      createdBy: map['CreatedBy'] != null ? UserModel.fromJson(map['CreatedBy']) : null,
      createdAt: map['CreatedAt'] != null ? DateTime.parse(map['CreatedAt']) : null,
      updatedAt: map['UpdatedAt'] != null ? DateTime.parse(map['UpdatedAt']) : null,
      groupMembers: (map['GroupMembers'] != null
          && map['GroupMembers'].length > 0 ?
        (map['GroupMembers'] as List<dynamic>)
          .map((groupMember) => GroupMemberModel.fromJson(groupMember))
          .toList()
        : []
      ),
      totalDrops: map['TotalDrops'] ?? 0,
    );
  }

  factory GroupModel.fromEntity(GroupModel entity) {
    return GroupModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      picturePath: entity.picturePath,
      isPrivate: entity.isPrivate,
      createdBy: entity.createdBy,
      drops: entity.drops,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      groupMembers: entity.groupMembers,
      totalDrops: entity.totalDrops,
    );
  }
}