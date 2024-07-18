import 'package:droppy/core/ressources/data_state.dart';
import 'package:droppy/core/usecases/usecase.dart';
import 'package:droppy/features/domain/entities/group_member.dart';
import 'package:droppy/features/domain/repository/group_repository.dart';

class RemoveManagerUseCase
    implements UseCase<DataState<GroupMemberEntity>, Map<String, dynamic>> {
  final GroupRepository _groupRepository;

  RemoveManagerUseCase(this._groupRepository);

  @override
  Future<DataState<GroupMemberEntity>> call(
      {Map<String, dynamic>? params}) async {
    return _groupRepository.removeManager(params!);
  }
}
