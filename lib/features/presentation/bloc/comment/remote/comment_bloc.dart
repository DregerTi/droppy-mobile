import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/ressources/data_state.dart';
import '../../../../domain/usecases/comment/post_comment.dart';
import 'comment_event.dart';
import 'comment_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {

  final PostCommentUseCase _postCommentUseCase;

  CommentsBloc(
      this._postCommentUseCase
  ) : super(
      const GetUserCommentsLoading()
  ){
    on <PostComment> (onPostComment);
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
  
}