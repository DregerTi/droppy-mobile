import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int ? id;
  final String ? email;
  final String ? avatar;
  final String ? firstname;
  final String ? lastname;
  final List ? roles;
  final String ? username;
  final String ? provider;
  final String ? phoneNumber;
  final String ? bio;

  const UserEntity({
    this.id,
    this.email,
    this.avatar,
    this.firstname,
    this.lastname,
    this.roles,
    this.username,
    this.provider,
    this.phoneNumber,
    this.bio
  });

  @override
  List<Object?> get props {
    return [
      id,
      email,
      avatar,
      firstname,
      lastname,
      roles,
      username,
      provider,
      phoneNumber,
      bio
    ];
  }
}