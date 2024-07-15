import 'dart:io';
import 'package:dio/dio.dart';
import '../../../core/ressources/data_state.dart';
import '../../domain/repository/follow_repository.dart';
import '../data_source/follow/follow_api_service.dart';
import '../models/follow.dart';

class FollowRepositoryImpl implements FollowRepository {
  final FollowApiService _followApiService;

  FollowRepositoryImpl(this._followApiService);

  @override
  Future<DataState<FollowModel>> postFollow(Map<String, dynamic> follow) async {
    try {
      final httpResponse = await _followApiService.postFollow(follow);
      if (httpResponse.response.statusCode == HttpStatus.created) {
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
  Future<DataState<Map<String, dynamic>>> deleteFollow(Map<String, dynamic> params) async {
    try {
      final httpResponse = await _followApiService.deleteFollow(id: params['id']);

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
  Future<DataState<FollowModel>> acceptFollow(Map<String, dynamic> params) async {
    try {
      final httpResponse = await _followApiService.acceptFollow(id: params['id']);
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
  Future<DataState<Map<String, dynamic>>> refuseFollow(Map<String, dynamic> params) async {
    try {
      final httpResponse = await _followApiService.refuseFollow(id: params['id']);
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

}