import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/ressources/data_state.dart';
import '../../domain/repository/auth_repository.dart';
import '../data_source/auth/auth_api_service.dart';
import '../models/auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _authApiService;

  AuthRepositoryImpl(this._authApiService);

  @override
  Future<DataState<AuthModel>> authenticate(Map<String, dynamic> credentials) async {
    try {
      final httpResponse = await _authApiService.authenticate(credentials);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailed(
          DioException(
            error: httpResponse.response.statusMessage,
            response: httpResponse.response,
            type: DioExceptionType.unknown,
            requestOptions: httpResponse.response.requestOptions,
          ),
        );
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<AuthModel>> refreshToken(Map<String, dynamic> params) async {
    try {
      final httpResponse = await _authApiService.refreshToken(params);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailed(
          DioException(
            error: httpResponse.response.statusMessage,
            response: httpResponse.response,
            type: DioExceptionType.unknown,
            requestOptions: httpResponse.response.requestOptions,
          ),
        );
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<AuthModel>> authOAuthToken(Map<String, dynamic> params) async {
    try {
      final httpResponse = await _authApiService.authOAuthToken(params);


      print(httpResponse.response.statusCode == HttpStatus.ok);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailed(
          DioException(
            error: httpResponse.response.statusMessage,
            response: httpResponse.response,
            type: DioExceptionType.unknown,
            requestOptions: httpResponse.response.requestOptions,
          ),
        );
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<bool>> signOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwtToken');
    await prefs.remove('refreshToken');
    await prefs.remove('id');
    await prefs.remove('roles');
    await prefs.remove('username');
    return const DataSuccess(true);
  }
}