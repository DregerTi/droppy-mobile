import '../../../../core/ressources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../repository/like_repository.dart';

class DeleteLikeUseCase implements UseCase<DataState<Map<String, dynamic>>, Map<String, dynamic>> {
  final LikeRepository _likeRepository;

  DeleteLikeUseCase(this._likeRepository);

  @override
  Future<DataState<Map<String, dynamic>>> call({Map<String, dynamic>? params}) async {
    return _likeRepository.deleteLike(params ?? {});
  }
}
