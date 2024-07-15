import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/ressources/data_state.dart';
import '../../../domain/usecases/comment/post_comment.dart';
import '../../../domain/usecases/comment_response/post_comment_response.dart';
import 'comment_event.dart';
import 'comment_state.dart';
class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {

  final PostCommentUseCase _postCommentUseCase;
  final PostCommentResponseUseCase _postCommentResponseUseCase;

  CommentsBloc(
      this._postCommentUseCase,
      this._postCommentResponseUseCase
  ) : super(
      const CommentInit()
  ){
    on <PostComment> (onPostComment);
    on <PostCommentResponse> (onPostCommentResponse);
  }

  void onPostComment(PostComment event, Emitter<CommentsState> emit) async {
    emit(
        const PostCommentLoading()
    );
    final dataState = await _postCommentUseCase(params: event.params);

    if(dataState is DataSuccess){
      emit(
        PostCommentDone(dataState.data!)
      );
    }

    if(dataState is DataFailed){
      emit(
        PostCommentError(dataState.error!)
      );
    }
  }

  void onPostCommentResponse(PostCommentResponse event, Emitter<CommentsState> emit) async {
    emit(
        const PostCommentResponseLoading()
    );
    final dataState = await _postCommentResponseUseCase(params: event.params);

    if(dataState is DataSuccess){
      emit(
          PostCommentResponseDone(dataState.data!)
      );
    }

    if(dataState is DataFailed){
      emit(
          PostCommentResponseError(dataState.error!)
      );
    }
  }
  
}