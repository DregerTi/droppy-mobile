import 'package:droppy/features/presentation/bloc/place_search/place_search_event.dart';
import 'package:droppy/features/presentation/bloc/place_search/place_search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/ressources/data_state.dart';
import '../../../domain/usecases/place_search/get_place_autocomplete.dart';
import '../../../domain/usecases/place_search/get_place_details.dart';
import '../../../domain/usecases/place_search/get_place_reverse_geocoding.dart';

class PlaceSearchBloc extends Bloc<PlaceSearchEvent, PlaceSearchState> {
  
  final GetPlaceAutocompleteUseCase _getPlaceAutocompleteUseCase;
  final GetPlaceDetailsUseCase _getPlaceDetailsUseCase;
  final GetPlaceReverseGeocodingUseCase _getPlaceReverseGeocodingUseCase;

  PlaceSearchBloc(
      this._getPlaceAutocompleteUseCase,
      this._getPlaceDetailsUseCase,
      this._getPlaceReverseGeocodingUseCase
  ) : super(
      const PlaceAutocompleteInitial()
  ){
    on <GetPlaceAutocomplete> (onGetPlaceAutocomplete);
    on <GetPlaceDetails> (onGetPlaceDetails);
    on <GetPlaceReverseGeocoding> (onGetPlaceReverseGeocoding);
  }
  
  void onGetPlaceAutocomplete(GetPlaceAutocomplete event, Emitter<PlaceSearchState> emit) async {
    emit(
      const PlaceAutocompleteLoading()
    );
    final dataState = await _getPlaceAutocompleteUseCase(params: event.params);

    if(dataState is DataSuccess && dataState.data!.isNotEmpty){
      emit(
        PlaceAutocompleteDone(dataState.data!)
      );
    }

    if(dataState is DataFailed){
      emit(
        PlaceAutocompleteError(dataState.error!)
      );
    }
  }

  void onGetPlaceDetails(GetPlaceDetails event, Emitter<PlaceSearchState> emit) async {
    emit(
        const PlaceDetailsLoading()
    );
    final dataState = await _getPlaceDetailsUseCase(params: event.params);

    if(dataState is DataSuccess && dataState.data?.lat != null){
      emit(
        PlaceDetailsDone(dataState.data!)
      );
    }

    if(dataState is DataFailed){
      emit(
        PlaceDetailsError(dataState.error!)
      );
    }
  }

  void onGetPlaceReverseGeocoding(GetPlaceReverseGeocoding event, Emitter<PlaceSearchState> emit) async {
    emit(
        const PlaceReverseGeocodingLoading()
    );
    final dataState = await _getPlaceReverseGeocodingUseCase(params: event.params);

    if(dataState is DataSuccess && dataState.data?.lat != null){
      emit(
        PlaceReverseGeocodingDone(dataState.data!)
      );
    }

    if(dataState is DataFailed){
      emit(
        PlaceReverseGeocodingError(dataState.error!)
      );
    }
  }
  
}