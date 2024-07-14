import '../../../../core/ressources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../repository/group_repository.dart';

class LeaveGroupUseCase implements UseCase<DataState<Map<String, dynamic>>, Map<String, dynamic>> {
  final GroupRepository _groupRepository;

  LeaveGroupUseCase(this._groupRepository);

  @override
  Future<DataState<Map<String, dynamic>>> call({Map<String, dynamic>? params}) async {
    return _groupRepository.leaveGroup(params ?? {});
  }
}