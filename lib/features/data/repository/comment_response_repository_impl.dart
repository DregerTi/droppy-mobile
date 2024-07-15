import 'dart:io';
import 'package:dio/dio.dart';
import '../../../core/ressources/data_state.dart';
import '../../domain/repository/comment_response_repository.dart';
import '../data_source/comment_response/comment_response_api_service.dart';
import '../models/comment_response.dart';

class CommentResponseRepositoryImpl implements CommentResponseRepository {
  final CommentResponseApiService _commentResponseApiService;

  CommentResponseRepositoryImpl(this._commentResponseApiService);

  @override
  Future<DataState<CommentResponseModel>> postCommentResponse(Map<String, dynamic> params) async {
    try {
      final httpResponse = await _commentResponseApiService.postCommentResponse(commentId: params['commentId'], commentResponse: params['commentResponse']);

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