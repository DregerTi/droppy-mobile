import '../../../../core/ressources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../data/models/place_search_details.dart';
import '../../repository/place_search_repository.dart';

class GetPlaceReverseGeocodingUseCase implements UseCase<DataState<PlaceSearchDetailsModel>, Map<String, dynamic>> {
  final PlaceSearchRepository _placeSearchRepository;

  GetPlaceReverseGeocodingUseCase(this._placeSearchRepository);

  @override
  Future<DataState<PlaceSearchDetailsModel>> call({Map<String, dynamic>? params}) async {
    return _placeSearchRepository.getPlaceReverseGeocoding(params ?? {});
  }
}