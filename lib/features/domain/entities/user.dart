import 'package:equatable/equatable.dart';

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

  const UserEntity({
    this.id,
    this.email,
    this.avatar,
    this.roles,
    this.username,
    this.provider,
    this.phoneNumber,
    this.bio,
    this.origin
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
      origin
    ];
  }
}