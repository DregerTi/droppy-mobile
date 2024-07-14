import '../../../core/ressources/data_state.dart';
import '../../data/models/follow.dart';

abstract class FollowRepository {

  Future<DataState<FollowModel>> postFollow(Map<String, dynamic> follow);

  Future<DataState<Map<String, dynamic>>> deleteFollow(Map<String, dynamic> params);

  Future<DataState<FollowModel>> acceptFollow(Map<String, dynamic> params);

  Future<DataState<Map<String, dynamic>>> refuseFollow(Map<String, dynamic> params);

}