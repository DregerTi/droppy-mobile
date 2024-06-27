import 'package:jwt_decoder/jwt_decoder.dart';

import '../../domain/entities/auth.dart';

class AuthModel extends AuthEntity {
  const AuthModel({
    String ? token,
    String ? refreshToken,
    int ? id,
    List<dynamic> ? roles,
    String ? username
  }) : super(
    token: token,
    refreshToken: refreshToken,
    id: id,
    roles: roles,
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
      roles: decodedToken['roles'] ?? "",
      username: decodedToken['username'] ?? "",
    );
  }

  factory AuthModel.fromEntity(AuthEntity entity) {
    return AuthModel(
      token: entity.token,
      refreshToken: entity.refreshToken,
      id: entity.id,
      roles: entity.roles,
      username: entity.username
    );
  }
}