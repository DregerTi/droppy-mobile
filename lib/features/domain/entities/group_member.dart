import 'package:droppy/features/data/models/group.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/user.dart';


class GroupMemberEntity extends Equatable {
  final int ? id;
  final int ? status;
  final String ? role;
  final UserModel ? member;
  final GroupModel ? group;
  final DateTime ? createdAt;
  final DateTime ? updatedAt;

  const GroupMemberEntity({
    this.id,
    this.status,
    this.role,
    this.member,
    this.group,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props {
    return [
      id,
      status,
      role,
      member,
      group,
      createdAt,
      updatedAt,
    ];
  }
}