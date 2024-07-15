import '../../../../core/ressources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../data/models/comment_response.dart';
import '../../repository/comment_response_repository.dart';

class PostCommentResponseUseCase implements UseCase<DataState<CommentResponseModel>, Map<String, dynamic>> {
  final CommentResponseRepository _commentResponseRepository;

  PostCommentResponseUseCase(this._commentResponseRepository);

  @override
  Future<DataState<CommentResponseModel>> call({Map<String, dynamic>? params}) async {
    return _commentResponseRepository.postCommentResponse(params!);
  }
}
