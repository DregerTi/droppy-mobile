import 'dart:io';

import 'package:dio/dio.dart';
import '../../../core/ressources/data_state.dart';
import '../../domain/repository/content_repository.dart';
import '../data_source/content/content_api_service.dart';
import '../models/content.dart';

class ContentRepositoryImpl implements ContentRepository {
  final ContentApiService _contentApiService;

  ContentRepositoryImpl(this._contentApiService);

  @override
  Future<DataState<List<ContentModel?>?>> searchContent(Map<String, dynamic> params) async {
    try {
      final httpResponse = await _contentApiService.searchContent(search: params['search']);

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