import '../../../core/ressources/data_state.dart';
import '../../data/models/comment.dart';

abstract class CommentRepository {

  Future<DataState<CommentModel>> postComment(Map<String, dynamic> comment);

}