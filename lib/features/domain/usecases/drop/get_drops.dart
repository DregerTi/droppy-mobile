import '../../../../core/ressources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/drop.dart';
import '../../repository/drop_repository.dart';

class GetDropsUseCase implements UseCase<DataState<List<DropEntity>>, Map<String, dynamic>> {
  final DropRepository _dropRepository;

  GetDropsUseCase(this._dropRepository);

  @override
  Future<DataState<List<DropEntity>>> call({Map<String, dynamic>? params}) async {
    return _dropRepository.getDrops(params ?? {});
  }
}