import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import '../../../../domain/entities/comment.dart';

abstract class CommentsState extends Equatable {
  final List<CommentEntity> ? comments;
  final CommentEntity ? comment;
  final DioException ? error;

  const CommentsState({this.comments, this.comment, this.error});

  @override
  List<Object?> get props => [comments, error];
}

class GetUserCommentsLoading extends CommentsState {
  const GetUserCommentsLoading();
}
class GetUserCommentsDone extends CommentsState {
  const GetUserCommentsDone(List<CommentEntity> comments) : super(comments: comments);
}
class GetUserCommentsError extends CommentsState {
  const GetUserCommentsError(DioException error) : super(error: error);
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