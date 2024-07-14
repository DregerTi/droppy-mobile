import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/follow.dart';

abstract class FollowsState extends Equatable {
  final FollowEntity ? follow;
  final DioException ? error;

  const FollowsState({ this.follow, this.error});

  @override
  List<Object?> get props => [ error];
}

class FollowsInitial extends FollowsState {
  const FollowsInitial();
}

class PostFollowLoading extends FollowsState {
  const PostFollowLoading();
}
class PostFollowDone extends FollowsState {
  const PostFollowDone(FollowEntity? follow) : super(follow: follow);
}
class PostFollowError extends FollowsState {
  const PostFollowError(DioException error) : super(error: error);
}

class DeleteFollowLoading extends FollowsState {
  const DeleteFollowLoading();
}
class DeleteFollowDone extends FollowsState {
  const DeleteFollowDone() : super();
}
class DeleteFollowError extends FollowsState {
  const DeleteFollowError(DioException error) : super(error: error);
}

class AcceptFollowLoading extends FollowsState {
  const AcceptFollowLoading();
}
class AcceptFollowDone extends FollowsState {
  const AcceptFollowDone(FollowEntity? follow) : super(follow: follow);
}
class AcceptFollowError extends FollowsState {
  const AcceptFollowError(DioException error) : super(error: error);
}

class RefuseFollowLoading extends FollowsState {
  const RefuseFollowLoading();
}
class RefuseFollowDone extends FollowsState {
  const RefuseFollowDone() : super();
}
class RefuseFollowError extends FollowsState {
  const RefuseFollowError(DioException error) : super(error: error);
}