import '../../../../core/ressources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/content.dart';
import '../../repository/content_repository.dart';

class SearchContentUseCase implements UseCase<DataState<List<ContentEntity?>?>, Map<String, dynamic>> {
  final ContentRepository _contentRepository;

  SearchContentUseCase(this._contentRepository);

  @override
  Future<DataState<List<ContentEntity?>?>> call({Map<String, dynamic>? params}) async {
    return _contentRepository.searchContent(params ?? {});
  }
}