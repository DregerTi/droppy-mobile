import '../../../../core/ressources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../repository/auth_repository.dart';

class SignOutUseCase implements UseCase<DataState<bool>, Map<String, dynamic>> {
  final AuthRepository _authRepository;

  SignOutUseCase(this._authRepository);

  @override
  Future<DataState<bool>> call({void params}) async {
    return _authRepository.signOut();
  }
}
