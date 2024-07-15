import '../../../core/ressources/data_state.dart';
import '../../data/models/comment_response.dart';

abstract class CommentResponseRepository {

  Future<DataState<CommentResponseModel>> postCommentResponse(Map<String, dynamic> params);

}