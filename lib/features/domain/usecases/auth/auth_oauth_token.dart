import '../../../../core/ressources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/auth.dart';
import '../../repository/auth_repository.dart';

class AuthOAuthTokenUseCase implements UseCase<DataState<AuthEntity>, Map<String, dynamic>> {
  final AuthRepository _authRepository;

  AuthOAuthTokenUseCase(this._authRepository);

  @override
  Future<DataState<AuthEntity>> call({Map<String, dynamic>? params}) async {
    return _authRepository.authOAuthToken(params ?? {});
  }
}
