import 'dart:io';

import 'package:dio/dio.dart';

import '../../../core/ressources/data_state.dart';
import '../../domain/repository/comment_repository.dart';
import '../data_source/comment/comment_api_service.dart';
import '../models/comment.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentApiService _commentApiService;

  CommentRepositoryImpl(this._commentApiService);

  @override
  Future<DataState<CommentModel>> postComment(Map<String, dynamic> params) async {
    try {
      final httpResponse = await _commentApiService.postComment(dropId: params['dropId'], comment: params['comment']);

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
}