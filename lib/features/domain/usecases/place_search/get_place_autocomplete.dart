import '../../../../core/ressources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../data/models/place_search_prediction.dart';
import '../../repository/place_search_repository.dart';

class GetPlaceAutocompleteUseCase implements UseCase<DataState<List<PlaceSearchPredictionModel>>, Map<String, dynamic>> {
  final PlaceSearchRepository _placeSearchRepository;

  GetPlaceAutocompleteUseCase(this._placeSearchRepository);

  @override
  Future<DataState<List<PlaceSearchPredictionModel>>> call({Map<String, dynamic>? params}) async {
    return _placeSearchRepository.getPlaceAutocomplete(params ?? {});
  }
}