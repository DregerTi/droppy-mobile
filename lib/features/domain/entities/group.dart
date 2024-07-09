import 'package:equatable/equatable.dart';
import '../../data/models/drop.dart';
import '../../data/models/user.dart';


class GroupEntity extends Equatable {
  final int ? id;
  final String ? name;
  final String ? description;
  final bool ? isPrivate;
  final String ? picturePath;
  final UserModel ? createdBy;
  final List<DropModel> ? drops;
  final DateTime ? createdAt;
  final DateTime ? updatedAt;

  const GroupEntity({
    this.id,
    this.name,
    this.description,
    this.isPrivate,
    this.picturePath,
    this.createdBy,
    this.drops,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props {
    return [
      id,
      name,
      description,
      isPrivate,
      picturePath,
      createdBy,
      drops,
      createdAt,
      updatedAt,
    ];
  }
}