import '../../../../core/ressources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/user.dart';
import '../../repository/user_repository.dart';

class PatchUserUseCase implements UseCase<DataState<UserEntity>, Map<String, dynamic>> {
  final UserRepository _userRepository;

  PatchUserUseCase(this._userRepository);

  @override
  Future<DataState<UserEntity>> call({Map<String, dynamic>? params}) async {
    return _userRepository.patchUser(params!);
  }
}
