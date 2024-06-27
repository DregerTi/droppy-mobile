import '../../../../core/ressources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../data/models/place_search_details.dart';
import '../../repository/place_search_repository.dart';

class GetPlaceDetailsUseCase implements UseCase<DataState<PlaceSearchDetailsModel>, Map<String, dynamic>> {
  final PlaceSearchRepository _placeSearchRepository;

  GetPlaceDetailsUseCase(this._placeSearchRepository);

  @override
  Future<DataState<PlaceSearchDetailsModel>> call({Map<String, dynamic>? params}) async {
    return _placeSearchRepository.getPlaceDetails(params ?? {});
  }
}