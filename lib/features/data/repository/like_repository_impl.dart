import 'dart:io';
import 'package:dio/dio.dart';
import '../../../core/ressources/data_state.dart';
import '../../domain/repository/like_repository.dart';
import '../data_source/like/like_api_service.dart';
import '../models/like.dart';

class LikeRepositoryImpl implements LikeRepository {
  final LikeApiService _likeApiService;

  LikeRepositoryImpl(this._likeApiService);

  @override
  Future<DataState<LikeModel>> postLike(Map<String, dynamic> like) async {
    try {
      final httpResponse = await _likeApiService.postLike(like);
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
  Future<DataState<Map<String, dynamic>>> deleteLike(Map<String, dynamic> params) async {
    try {
      final httpResponse = await _likeApiService.deleteLike(likeId: params['likeId']);

      if (httpResponse.response.statusCode == HttpStatus.noContent) {
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
  Future<DataState<List<LikeModel>>> getUserLikes(Map<String, dynamic> params) async {
    try {
      final httpResponse = await _likeApiService.getUserLikes(userId: params['userId']);

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