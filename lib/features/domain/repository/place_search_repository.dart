import '../../../core/ressources/data_state.dart';
import '../../data/models/place_search_details.dart';
import '../../data/models/place_search_prediction.dart';

abstract class PlaceSearchRepository {

  Future<DataState<List<PlaceSearchPredictionModel>>> getPlaceAutocomplete(Map<String, dynamic> params);

  Future<DataState<PlaceSearchDetailsModel>> getPlaceDetails(Map<String, dynamic> params);

  Future<DataState<PlaceSearchDetailsModel>> getPlaceReverseGeocoding(Map<String, dynamic> params);

}