import 'package:droppy/features/domain/entities/auth.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/ressources/data_state.dart';
import '../../../domain/usecases/auth/authenticate.dart';
import '../../../domain/usecases/auth/refresh_token.dart';
import '../../../domain/usecases/auth/sign_out.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticateUseCase _authenticateUseCase;
  final SignOutUseCase _signOutUseCase;
  final RefreshTokenUseCase _refreshTokenUseCase;

  AuthBloc(
      this._authenticateUseCase,
      this._signOutUseCase,
      this._refreshTokenUseCase,
      ) : super(const AuthUnauthenticated()){
    on <Authenticate> (onAuthenticate);
    on <OAuthAuthenticate> (onOAuthAuthenticate);
    on<SignOut>(onSignOut);
    on<RefreshToken>(onRefreshToken);
  }

  void onAuthenticate(Authenticate event, Emitter<AuthState> emit) async {
    emit(
        const AuthLoading()
    );
    final dataState = await _authenticateUseCase(params: event.credentials);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<dynamic, dynamic> decodedToken = {};

    if(dataState is DataSuccess && dataState.data != null){

      if (dataState.data!.token != null){
        decodedToken = JwtDecoder.decode(dataState.data!.token ?? '');
      }

      await prefs.setString('jwtToken', dataState.data!.token ?? '');
      await prefs.setString('refreshToken', dataState.data!.refreshToken ?? '');
      await prefs.setInt('id', decodedToken['sub'] ?? 1);
      await prefs.setString('role',decodedToken['role'] ?? '');
      await prefs.setString('username', decodedToken['username'] ?? '');

      AuthEntity auth = AuthEntity(
          token: dataState.data!.token ?? '',
          refreshToken: dataState.data!.refreshToken ?? '',
          id: decodedToken['sub'] ?? 1,
          role: decodedToken['role'] ?? '',
          username: decodedToken['username'] ?? ''
      );

      emit(
          AuthDone(auth)
      );
    }
    if(dataState is DataFailed){
      emit(
          AuthError(dataState.error!)
      );
    }
  }

  void onOAuthAuthenticate(OAuthAuthenticate event, Emitter<AuthState> emit) async {
    emit(
        const AuthLoading()
    );
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<dynamic, dynamic> decodedToken = {};

    if(event.auth.token != null){
      decodedToken = JwtDecoder.decode(event.auth.token ?? '');
    }

    await prefs.setString('jwtToken', event.auth.token ?? '');
    await prefs.setString('refreshToken', event.auth.refreshToken ?? '');
    await prefs.setInt('id', decodedToken['sub'] ?? 0);
    await prefs.setString('role',decodedToken['role'] ?? '');
    await prefs.setString('username', decodedToken['username'] ?? '');

    final auth = AuthEntity(
        token: event.auth.token ?? '',
        refreshToken: event.auth.refreshToken ?? '',
        id: decodedToken['sub'] ?? 0,
        role: decodedToken['role'] ?? '',
    );

    emit(
        AuthDone(auth)
    );
  }

  void onRefreshToken(RefreshToken event, Emitter<AuthState> emit) async {
    emit(
        const AuthUnauthenticated()
    );
    final dataState = await _refreshTokenUseCase(params: event.refreshToken);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<dynamic, dynamic> decodedToken = {};

    if(dataState is DataSuccess && dataState.data != null){

      if (dataState.data!.token != null){
        decodedToken = JwtDecoder.decode(dataState.data!.token ?? '');
      }

      await prefs.setString('jwtToken', dataState.data!.token ?? '');
      await prefs.setString('refreshToken', dataState.data!.refreshToken ?? '');
      await prefs.setInt('id', decodedToken['sub'] ?? 0);
      await prefs.setString('role',decodedToken['role'] ?? '');
      await prefs.setString('username', decodedToken['username'] ?? '');

      emit(
          AuthDone(dataState.data!)
      );
    }
    if(dataState is DataFailed){
      emit(
          AuthError(dataState.error!)
      );
    }
  }

  void onSignOut(SignOut event, Emitter<AuthState> emit) async {
    final dataState = await _signOutUseCase();
    if(dataState is DataSuccess){
      emit(
          const AuthUnauthenticated()
      );
    }
  }
}