import 'dart:io';

import 'package:dio/dio.dart';
import '../../../core/constants/constants.dart';
import '../../../core/ressources/data_state.dart';
import '../../domain/repository/place_search_repository.dart';
import '../data_source/place_search/place_search_api_service.dart';
import '../models/place_search_details.dart';
import '../models/place_search_prediction.dart';

class PlaceSearchRepositoryImpl implements PlaceSearchRepository {
  final PlaceSearchApiService _placeSearchApiService;

  PlaceSearchRepositoryImpl(this._placeSearchApiService);

  @override
  Future<DataState<List<PlaceSearchPredictionModel>>> getPlaceAutocomplete(Map<String, dynamic> params) async {
    try {
      final httpResponse = await _placeSearchApiService.getPlaceAutocomplete(
        input: params['input'],
        language: params['language'],
        key: placeApiKey,
      );

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
  Future<DataState<PlaceSearchDetailsModel>> getPlaceDetails(Map<String, dynamic> params) async {
    try {
      final httpResponse = await _placeSearchApiService.getPlaceDetails(
        fields: params['fields'],
        placeId: params['placeId'],
        key: placeApiKey,
      );

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
  Future<DataState<PlaceSearchDetailsModel>> getPlaceReverseGeocoding(Map<String, dynamic> params) async {
    try {
      final httpResponse = await _placeSearchApiService.getPlaceReverseGeocoding(
        latlng: params['latlng'],
        key: placeApiKey,
      );

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