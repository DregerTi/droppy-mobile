import 'package:droppy/features/domain/entities/user.dart';

import '../../../../core/ressources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../repository/user_repository.dart';

class GetUsersSearchUseCase implements UseCase<DataState<List<UserEntity?>?>, Map<String, dynamic>> {
  final UserRepository _userRepository;

  GetUsersSearchUseCase(this._userRepository);

  @override
  Future<DataState<List<UserEntity?>?>> call({Map<String, dynamic>? params}) async {
    return _userRepository.getUsersSearch(params ?? {});
  }
}