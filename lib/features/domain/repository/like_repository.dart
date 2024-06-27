import '../../../core/ressources/data_state.dart';
import '../../data/models/like.dart';

abstract class LikeRepository {

  Future<DataState<List<LikeModel>>> getUserLikes(Map<String, dynamic> params);

  Future<DataState<LikeModel>> postLike(Map<String, dynamic> like);

  Future<DataState<Map<String, dynamic>>> deleteLike(Map<String, dynamic> params);

}