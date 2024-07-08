import 'package:jwt_decoder/jwt_decoder.dart';

import '../../domain/entities/auth.dart';

class AuthModel extends AuthEntity {
  const AuthModel({
    String ? token,
    String ? refreshToken,
    int ? id,
    String ? role,
    String ? username
  }) : super(
    token: token,
    refreshToken: refreshToken,
    id: id,
    role: role,
    username: username
  );

  factory AuthModel.fromJson(Map<dynamic, dynamic > map) {

    Map<dynamic, dynamic> decodedToken = {};

    if (map['jwtToken'] != null){
      decodedToken = JwtDecoder.decode(map['jwtToken']);
    }

    return AuthModel(
      token: map['jwtToken'] ?? "",
      refreshToken: map['refreshToken'] ?? "",
      id: decodedToken['ID'] ?? 0,
      role: decodedToken['role'] ?? "",
      username: decodedToken['username'] ?? "",
    );
  }

  factory AuthModel.fromEntity(AuthEntity entity) {
    return AuthModel(
      token: entity.token,
      refreshToken: entity.refreshToken,
      id: entity.id,
      role: entity.role,
      username: entity.username
    );
  }
}