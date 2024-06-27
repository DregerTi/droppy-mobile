import '../../../../core/ressources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../data/models/comment.dart';
import '../../repository/comment_repository.dart';

class PostCommentUseCase implements UseCase<DataState<CommentModel>, Map<String, dynamic>> {
  final CommentRepository _commentRepository;

  PostCommentUseCase(this._commentRepository);

  @override
  Future<DataState<CommentModel>> call({Map<String, dynamic>? params}) async {
    return _commentRepository.postComment(params!);
  }
}
