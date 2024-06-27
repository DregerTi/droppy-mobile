import '../../../../core/ressources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/user.dart';
import '../../repository/user_repository.dart';

class GetUsersUseCase implements UseCase<DataState<List<UserEntity>>, void> {
  final UserRepository _userRepository;

  GetUsersUseCase(this._userRepository);

  @override
  Future<DataState<List<UserEntity>>> call({void params}) async {
    return _userRepository.getUsers();
  }
}