import '../../../../core/ressources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/drop.dart';
import '../../repository/drop_repository.dart';

class GetDropUseCase implements UseCase<DataState<DropEntity>, Map<String, dynamic>> {
  final DropRepository _dropRepository;

  GetDropUseCase(this._dropRepository);

  @override
  Future<DataState<DropEntity>> call({Map<String, dynamic>? params}) async {
    return _dropRepository.getDrop(params ?? {});
  }
}