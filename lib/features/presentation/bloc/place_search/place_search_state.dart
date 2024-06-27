import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/place_search_details.dart';
import '../../../data/models/place_search_prediction.dart';

abstract class PlaceSearchState extends Equatable {
  final List<PlaceSearchPredictionModel> ? placeSearchs;
  final PlaceSearchDetailsModel ? placeSearch;
  final DioException ? error;

  const PlaceSearchState({this.placeSearchs, this.placeSearch, this.error});

  @override
  List<Object?> get props => [placeSearchs, error];
}

class PlaceAutocompleteInitial extends PlaceSearchState {
  const PlaceAutocompleteInitial() : super();
}
class PlaceAutocompleteLoading extends PlaceSearchState {
  const PlaceAutocompleteLoading();
}
class PlaceAutocompleteDone extends PlaceSearchState {
  const PlaceAutocompleteDone(List<PlaceSearchPredictionModel> placeSearchs) : super(placeSearchs: placeSearchs);
}
class PlaceAutocompleteError extends PlaceSearchState {
  const PlaceAutocompleteError(DioException error) : super(error: error);
}


class PlaceDetailsLoading extends PlaceSearchState {
  const PlaceDetailsLoading();
}
class PlaceDetailsDone extends PlaceSearchState {
  const PlaceDetailsDone(PlaceSearchDetailsModel placeSearch) : super(placeSearch: placeSearch);
}
class PlaceDetailsError extends PlaceSearchState {
  const PlaceDetailsError(DioException error) : super(error: error);
}


class PlaceReverseGeocodingLoading extends PlaceSearchState {
  const PlaceReverseGeocodingLoading();
}
class PlaceReverseGeocodingDone extends PlaceSearchState {
  const PlaceReverseGeocodingDone(PlaceSearchDetailsModel placeSearch) : super(placeSearch: placeSearch);
}
class PlaceReverseGeocodingError extends PlaceSearchState {
  const PlaceReverseGeocodingError(DioException error) : super(error: error);
}