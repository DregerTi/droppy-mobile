import '../../../../core/ressources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/group.dart';
import '../../repository/group_repository.dart';

class GetGroupFeedUseCase implements UseCase<DataState<GroupEntity?>, Map<String, dynamic>> {
  final GroupRepository _groupRepository;

  GetGroupFeedUseCase(this._groupRepository);

  @override
  Future<DataState<GroupEntity?>> call({Map<String, dynamic>? params}) async {
    return _groupRepository.getGroupFeed(params ?? {});
  }
}