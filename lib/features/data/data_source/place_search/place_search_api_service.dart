import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/constants/constants.dart';
import '../../models/place_search_details.dart';
import '../../models/place_search_prediction.dart';
part 'place_search_api_service.g.dart';

@RestApi(baseUrl:placeApiBaseUrl)
abstract class PlaceSearchApiService {
  factory PlaceSearchApiService(Dio dio) = _PlaceSearchApiService;

  @GET("/place/autocomplete/json")
  Future<HttpResponse<List<PlaceSearchPredictionModel>>> getPlaceAutocomplete({
    @Query("input") String ? input,
    @Query("language") String ? language,
    @Query("key") String ? key,
  });

  @GET("/place/details/json")
  Future<HttpResponse<PlaceSearchDetailsModel>> getPlaceDetails({
    @Query("fields") String ? fields,
    @Query("place_id") String ? placeId,
    @Query("key") String ? key,
  });

  @GET("/geocode/json")
  Future<HttpResponse<PlaceSearchDetailsModel>> getPlaceReverseGeocoding({
    @Query("latlng") String ? latlng,
    @Query("key") String ? key,
  });
}