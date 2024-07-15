import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/comment.dart';
import '../../../domain/entities/comment_response.dart';

abstract class CommentsState extends Equatable {
  final CommentEntity ? comment;
  final CommentResponseEntity ? commentResponse;
  final DioException ? error;

  const CommentsState({ this.comment, this.commentResponse, this.error});

  @override
  List<Object?> get props => [comment, error];
}

class CommentInit extends CommentsState {
  const CommentInit();
}

class PostCommentLoading extends CommentsState {
  const PostCommentLoading();
}
class PostCommentDone extends CommentsState {
  const PostCommentDone(CommentEntity comment) : super(comment: comment);
}
class PostCommentError extends CommentsState {
  const PostCommentError(DioException error) : super(error: error);
}

class PostCommentResponseLoading extends CommentsState {
  const PostCommentResponseLoading();
}
class PostCommentResponseDone extends CommentsState {
  const PostCommentResponseDone(CommentResponseEntity commentResponse) : super(commentResponse: commentResponse);
}
class PostCommentResponseError extends CommentsState {
  const PostCommentResponseError(DioException error) : super(error: error);
}