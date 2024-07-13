import 'package:equatable/equatable.dart';

import '../../data/models/drop.dart';
import '../../data/models/group.dart';

class UserEntity extends Equatable {
  final int ? id;
  final String ? email;
  final String ? avatar;
  final List ? roles;
  final String ? username;
  final String ? provider;
  final String ? phoneNumber;
  final String ? bio;
  final List<dynamic> ? origin;
  final int ? totalFollowers;
  final int ? totalFollowed;
  final DropModel ? lastDrop;
  final List<DropModel> ? pinnedDrops;
  final List<GroupModel> ? groups;
  final int ? totalDrops;

  const UserEntity({
    this.id,
    this.email,
    this.avatar,
    this.roles,
    this.username,
    this.provider,
    this.phoneNumber,
    this.bio,
    this.origin,
    this.totalFollowers,
    this.totalFollowed,
    this.lastDrop,
    this.pinnedDrops,
    this.groups,
    this.totalDrops,
  });

  @override
  List<Object?> get props {
    return [
      id,
      email,
      avatar,
      roles,
      username,
      provider,
      phoneNumber,
      bio,
      origin,
      totalFollowers,
      totalFollowed,
      lastDrop,
      pinnedDrops,
      groups,
      totalDrops,
    ];
  }
}