import '../../../../core/ressources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/auth.dart';
import '../../repository/auth_repository.dart';

class RefreshTokenUseCase implements UseCase<DataState<AuthEntity>, Map<String, dynamic>> {
  final AuthRepository _authRepository;

  RefreshTokenUseCase(this._authRepository);

  @override
  Future<DataState<AuthEntity>> call({Map<String, dynamic>? params}) async {
    return _authRepository.refreshToken(params ?? {});
  }
}
