import 'package:dio/dio.dart';
import '../../../domain/entities/auth.dart';

abstract class OAuthState {
  final AuthEntity ? auth;
  final DioException ? error;

  const OAuthState({this.auth, this.error});

  @override
  List<Object?> get props => [auth, error];
}

class OAuthInit extends OAuthState {
  OAuthInit();
}

class OAuthLoading extends OAuthState {
  OAuthLoading();
}

class OAuthDone extends OAuthState {
  OAuthDone(AuthEntity auth) : super(auth: auth);
}

class OAuthError extends OAuthState {
  final String errorFirebase;

  OAuthError(this.errorFirebase);
}
