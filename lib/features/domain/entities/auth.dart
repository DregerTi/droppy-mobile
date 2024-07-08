import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String ? token;
  final String ? refreshToken;
  final int ? id;
  final String ? role;
  final String ? username;

  const AuthEntity({
    this.token,
    this.refreshToken,
    this.id,
    this.role,
    this.username
  });

  @override
  List<Object?> get props {
    return [
      token,
      refreshToken,
      id,
      role,
      username
    ];
  }
}