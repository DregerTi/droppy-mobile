import '../../../../core/ressources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../repository/drop_repository.dart';

class DeleteLikeUseCase implements UseCase<DataState<dynamic>, Map<String, dynamic>> {
  final DropRepository _dropRepository;

  DeleteLikeUseCase(this._dropRepository);

  @override
  Future<DataState<dynamic>> call({Map<String, dynamic>? params}) async {
    return _dropRepository.deleteLike(params!);
  }
}
