import '../../../../core/ressources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../data/models/like.dart';
import '../../repository/like_repository.dart';

class GetUserLikesUseCase implements UseCase<DataState<List<LikeModel>>, Map<String, dynamic>> {
  final LikeRepository _likeRepository;

  GetUserLikesUseCase(this._likeRepository);

  @override
  Future<DataState<List<LikeModel>>> call({Map<String, dynamic>? params}) async {
    return _likeRepository.getUserLikes(params ?? {});
  }
}