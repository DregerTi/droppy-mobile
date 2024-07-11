import '../../../../core/ressources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/group.dart';
import '../../repository/group_repository.dart';

class GetGroupUseCase implements UseCase<DataState<GroupEntity>, Map<String, dynamic>> {
  final GroupRepository _groupRepository;

  GetGroupUseCase(this._groupRepository);

  @override
  Future<DataState<GroupEntity>> call({Map<String, dynamic>? params}) async {
    return _groupRepository.getGroup(params ?? {});
  }
}