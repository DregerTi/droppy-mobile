import 'package:droppy/features/domain/entities/group_member.dart';

import '../../../../core/ressources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../repository/group_repository.dart';

class LeaveGroupUseCase implements UseCase<DataState<GroupMemberEntity>, Map<String, dynamic>> {
  final GroupRepository _groupRepository;

  LeaveGroupUseCase(this._groupRepository);

  @override
  Future<DataState<GroupMemberEntity>> call({Map<String, dynamic>? params}) async {
    return _groupRepository.leaveGroup(params ?? {});
  }
}