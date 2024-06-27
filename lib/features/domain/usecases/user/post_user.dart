import '../../../../core/ressources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/user.dart';
import '../../repository/user_repository.dart';

class PostUserUseCase implements UseCase<DataState<UserEntity>, Map<String, dynamic>> {
  final UserRepository _userRepository;

  PostUserUseCase(this._userRepository);

  @override
  Future<DataState<UserEntity>> call({Map<String, dynamic>? params}) async {
    return _userRepository.postUser(params!);
  }
}
