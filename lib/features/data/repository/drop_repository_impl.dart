import 'dart:io';

import 'package:dio/dio.dart';
import '../data_source/drop/drop_api_service.dart';
import '../../../core/ressources/data_state.dart';
import '../../domain/repository/drop_repository.dart';
import '../models/drop.dart';

class DropRepositoryImpl implements DropRepository {
  final DropApiService _dropApiService;

  DropRepositoryImpl(this._dropApiService);

  @override
  Future<DataState<List<DropModel>>> getDrops(Map<String, dynamic> params) async {
    try {
      final httpResponse = await _dropApiService.getDrops();

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
  Future<DataState<DropModel>> getDrop(Map<String, dynamic> params) async {
    final httpResponse = await _dropApiService.getDrop(id: params['id']);
    return DataSuccess(httpResponse.data);
    /*try {
      final httpResponse = await _dropApiService.getDrop(id: params['id']);
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
    }*/
  }

  @override
  Future<DataState<List<DropModel>>> getUserDrops(Map<String, dynamic> params) async {
    try {
      final httpResponse = await _dropApiService.getUserDrops(id: params['id']);

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
  Future<DataState<DropModel>> postDrop(Map<String, dynamic> params) async {
    try {
      final httpResponse = await _dropApiService.postDrop(params);

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
  Future<DataState<dynamic>> deleteDrop(Map<String, dynamic> params) async {
    try {
      final httpResponse = await _dropApiService.deleteDrop(id: params['id']);

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
  Future<DataState<DropModel>> postLike(Map<String, dynamic> params) async {
    try {
      final httpResponse = await _dropApiService.postLike(id: params['id']);

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
  Future<DataState<dynamic>> deleteLike(Map<String, dynamic> params) async {
    try {
      final httpResponse = await _dropApiService.deleteLike(id: params['id']);

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
  Future<DataState<DropModel>> patchDrop(Map<String, dynamic> params) async {
    try {
      final httpResponse = await _dropApiService.patchDrop(id: params['id'], drop: params['drop']);

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