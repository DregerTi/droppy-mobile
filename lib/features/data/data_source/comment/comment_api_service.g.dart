// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_api_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _CommentApiService implements CommentApiService {
  _CommentApiService(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= apiBaseUrl;
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<HttpResponse<CommentModel>> postComment({
    required int dropId,
    required Map<String, dynamic> comment,
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = comment;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<CommentModel>>(
            Options(
              method: 'POST',
              headers: _headers,
              extra: _extra,
            ).compose(
              _dio.options,
              '/drops/$dropId/comments',
              queryParameters: queryParameters,
              data: _data,
            )).copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)));
    final value = CommentModel.fromJson(_result.data!);
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
