import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String ? token;
  final String ? refreshToken;
  final int ? id;
  final List<dynamic> ? roles;
  final String ? username;

  const AuthEntity({
    this.token,
    this.refreshToken,
    this.id,
    this.roles,
    this.username
  });

  @override
  List<Object?> get props {
    return [
      token,
      refreshToken,
      id,
      roles,
      username
    ];
  }
}