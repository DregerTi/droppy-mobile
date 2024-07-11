import 'package:dio/dio.dart';
import 'package:droppy/features/domain/entities/drop.dart';
import 'package:equatable/equatable.dart';

abstract class LikesState extends Equatable {
  final DropEntity ? drop;
  final DioException ? error;

  const LikesState({ this.drop, this.error});

  @override
  List<Object?> get props => [ error];
}

class LikesInitial extends LikesState {
  const LikesInitial();
}

class PostLikeLoading extends LikesState {
  const PostLikeLoading();
}
class PostLikeDone extends LikesState {
  const PostLikeDone(DropEntity? drop) : super(drop: drop);
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