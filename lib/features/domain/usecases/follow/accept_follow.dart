import '../../../../core/ressources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/follow.dart';
import '../../repository/follow_repository.dart';

class AcceptFollowUseCase implements UseCase<DataState<FollowEntity>, Map<String, dynamic>> {
  final FollowRepository _followRepository;

  AcceptFollowUseCase(this._followRepository);

  @override
  Future<DataState<FollowEntity>> call({Map<String, dynamic>? params}) async {
    return _followRepository.acceptFollow(params!);
  }
}
