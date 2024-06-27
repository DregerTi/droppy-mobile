import '../../../../core/ressources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/user.dart';
import '../../repository/user_repository.dart';

class GetUserUseCase implements UseCase<DataState<UserEntity>, Map<String, dynamic>> {
  final UserRepository _userRepository;

  GetUserUseCase(this._userRepository);

  @override
  Future<DataState<UserEntity>> call({Map<String, dynamic>? params}) async {
    return _userRepository.getUser(params ?? {});
  }
}