import '../../../../core/ressources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../data/models/like.dart';
import '../../repository/like_repository.dart';

class PostLikeUseCase implements UseCase<DataState<LikeModel>, Map<String, dynamic>> {
  final LikeRepository _likeRepository;

  PostLikeUseCase(this._likeRepository);

  @override
  Future<DataState<LikeModel>> call({Map<String, dynamic>? params}) async {
    return _likeRepository.postLike(params!);
  }
}
