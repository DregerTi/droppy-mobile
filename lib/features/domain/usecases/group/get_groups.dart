import '../../../../core/ressources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/group.dart';
import '../../repository/group_repository.dart';

class GetGroupsUseCase implements UseCase<DataState<List<GroupEntity>>, Map<String, dynamic>> {
  final GroupRepository _groupRepository;

  GetGroupsUseCase(this._groupRepository);

  @override
  Future<DataState<List<GroupEntity>>> call({Map<String, dynamic>? params}) async {
    return _groupRepository.getGroups(params ?? {});
  }
}