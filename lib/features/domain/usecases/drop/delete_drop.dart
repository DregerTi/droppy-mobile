import '../../../../core/ressources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../repository/drop_repository.dart';

class DeleteDropUseCase implements UseCase<DataState<dynamic>, Map<String, dynamic>> {
  final DropRepository _dropRepository;

  DeleteDropUseCase(this._dropRepository);

  @override
  Future<DataState<dynamic>> call({Map<String, dynamic>? params}) async {
    return _dropRepository.deleteDrop(params!);
  }
}
