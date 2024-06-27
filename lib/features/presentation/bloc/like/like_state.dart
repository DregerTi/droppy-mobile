import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/like.dart';
import '../../../domain/entities/like.dart';

abstract class LikesState extends Equatable {
  final List<LikeModel> ? likes;
  final LikeEntity ? like;
  final DioException ? error;

  const LikesState({this.likes, this.like, this.error});

  @override
  List<Object?> get props => [likes, error];
}

class LikesLoading extends LikesState {
  const LikesLoading();
}
class LikesDone extends LikesState {
  const LikesDone(List<LikeModel> likes) : super(likes: likes);
}
class LikesError extends LikesState {
  const LikesError(DioException error) : super(error: error);
}

class PostLikeLoading extends LikesState {
  const PostLikeLoading();
}
class PostLikeDone extends LikesState {
  const PostLikeDone(LikeEntity like) : super(like: like);
}
class PostLikeError extends LikesState {
  const PostLikeError(DioException error) : super(error: error);
}

class DeleteLikeLoading extends LikesState {
  const DeleteLikeLoading();
}
class DeleteLikeDone extends LikesState {
  const DeleteLikeDone() : super();
}
class DeleteLikeError extends LikesState {
  const DeleteLikeError(DioException error) : super(error: error);
}