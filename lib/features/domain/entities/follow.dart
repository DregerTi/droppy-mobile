import 'package:equatable/equatable.dart';
import '../../data/models/user.dart';

class FollowEntity extends Equatable {
  final int ? id;
  final UserModel ? followed;
  final UserModel ? follower;
  final DateTime ? createdAt;
  final DateTime ? updatedAt;
  final int ? status;

  const FollowEntity({
    this.id,
    this.followed,
    this.follower,
    this.createdAt,
    this.updatedAt,
    this.status
  });

  @override
  List<Object?> get props {
    return [
      id,
      followed,
      follower,
      createdAt,
      updatedAt,
      status
    ];
  }
}