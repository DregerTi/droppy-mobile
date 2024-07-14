import 'dart:io';

import 'package:dio/dio.dart';
import '../../../core/ressources/data_state.dart';
import '../../domain/entities/group_member.dart';
import '../../domain/repository/group_repository.dart';
import '../data_source/goup/group_api_service.dart';
import '../models/group.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupApiService _groupApiService;

  GroupRepositoryImpl(this._groupApiService);

  @override
  Future<DataState<List<GroupModel?>?>> getGroups(Map<String, dynamic> params) async {
    try {
      final httpResponse = await _groupApiService.getGroups(search: params['search']);

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
  Future<DataState<GroupModel>> getGroup(Map<String, dynamic> params) async {
    try {
      final httpResponse = await _groupApiService.getGroup(id: params['id']);
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
  Future<DataState<GroupModel>> patchGroup(Map<String, dynamic> params) async {
    try {
      final httpResponse = await _groupApiService.patchGroup(id: params['id'], group: params['group']);

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
  Future<DataState<GroupMemberEntity>> postGroupJoin(Map<String, dynamic> params) async {
    try {
      final httpResponse = await _groupApiService.postGroupJoin(id: params['id']);

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
  Future<DataState<Map<String, dynamic>>> leaveGroup(Map<String, dynamic> params) async {
    try {
      final httpResponse = await _groupApiService.leaveGroup(id: params['id'], memberId: params['memberId']);

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
  Future<DataState<GroupMemberEntity>> postGroupMember(Map<String, dynamic> params) async {
    try {
      final httpResponse = await _groupApiService.postGroupMember(id: params['id'], memberId: params['memberId']);

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
  Future<DataState<GroupModel>> postGroup(Map<String, dynamic> params) async {
    try {
      final httpResponse = await _groupApiService.postGroup(params);

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
  Future<DataState<GroupModel?>> getGroupFeed(Map<String, dynamic> params) async {
    try {
      final httpResponse = await _groupApiService.getGroupFeed(id: params['id']);

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