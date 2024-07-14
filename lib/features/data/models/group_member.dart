import 'package:droppy/features/data/models/group.dart';
import 'package:droppy/features/data/models/user.dart';
import '../../domain/entities/group_member.dart';

class GroupMemberModel extends GroupMemberEntity {
  const GroupMemberModel({
    int ? id,
    int ? status,
    String ? role,
    UserModel ? member,
    GroupModel ? group,
    DateTime ? createdAt,
    DateTime ? updatedAt,
  }) : super(
    id: id,
    status: status,
    role: role,
    member: member,
    group: group,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
  
  factory GroupMemberModel.fromJson(Map<String, dynamic >map) {
    return GroupMemberModel(
      id: map['ID'] ?? "",
      status: map['Status'] ?? "",
      role: map['Role'] ?? "",
      member: map['Member'] != null ? UserModel.fromJson(map['Member']) : null,
      group: map['Group'] != null ? GroupModel.fromJson(map['Group']) : null,
      createdAt: map['CreatedAt'] != null ? DateTime.parse(map['CreatedAt']) : null,
      updatedAt: map['UpdatedAt'] != null ? DateTime.parse(map['UpdatedAt']) : null,
    );
  }

  factory GroupMemberModel.fromEntity(GroupMemberModel entity) {
    return GroupMemberModel(
      id: entity.id,
      status: entity.status,
      role: entity.role,
      member: entity.member,
      group: entity.group,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}