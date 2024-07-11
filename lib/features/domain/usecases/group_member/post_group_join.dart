import '../../../../core/ressources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/group_member.dart';
import '../../repository/group_repository.dart';

class PostGroupJoinUseCase implements UseCase<DataState<GroupMemberEntity>, Map<String, dynamic>> {
  final GroupRepository _groupRepository;

  PostGroupJoinUseCase(this._groupRepository);

  @override
  Future<DataState<GroupMemberEntity>> call({Map<String, dynamic>? params}) async {
    return _groupRepository.postGroupJoin(params!);
  }
}
