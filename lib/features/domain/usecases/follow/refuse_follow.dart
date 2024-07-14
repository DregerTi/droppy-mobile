import '../../../../core/ressources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../repository/follow_repository.dart';

class RefuseFollowUseCase implements UseCase<DataState<dynamic>, Map<String, dynamic>> {
  final FollowRepository _followRepository;

  RefuseFollowUseCase(this._followRepository);

  @override
  Future<DataState<dynamic>> call({Map<String, dynamic>? params}) async {
    return _followRepository.refuseFollow(params!);
  }
}
