import '../../../domain/entities/auth.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class Authenticate extends AuthEvent {
  final Map<String, dynamic> credentials;

  const Authenticate(this.credentials);
}

class OAuthAuthenticate extends AuthEvent {
  final AuthEntity auth;

  const OAuthAuthenticate(this.auth);
}

class RefreshToken extends AuthEvent {
  final Map<String, dynamic> refreshToken;

  const RefreshToken(this.refreshToken);
}

class SignOut extends AuthEvent {
  const SignOut();
}