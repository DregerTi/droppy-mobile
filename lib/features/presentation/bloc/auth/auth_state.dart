import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/auth.dart';

abstract class AuthState extends Equatable {
  final AuthEntity ? auth;
  final DioException ? error;

  const AuthState({this.auth, this.error});

  @override
  List<Object?> get props => [auth, error];
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthDone extends AuthState {
  const AuthDone(AuthEntity auth) : super(auth: auth);

  get token => null;
}

class AuthError extends AuthState {
  const AuthError(DioException error) : super(error: error);
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}
