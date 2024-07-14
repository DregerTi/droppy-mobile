import '../../../../core/ressources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../repository/follow_repository.dart';

class DeleteFollowUseCase implements UseCase<DataState<dynamic>, Map<String, dynamic>> {
  final FollowRepository _followRepository;

  DeleteFollowUseCase(this._followRepository);

  @override
  Future<DataState<dynamic>> call({Map<String, dynamic>? params}) async {
    return _followRepository.deleteFollow(params!);
  }
}
