import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/drop.dart';

abstract class DropsState extends Equatable {
  final List<DropEntity> ? drops;
  final List<DropEntity> ? userDrops;
  final DropEntity ? drop;
  final DropEntity ? newDrop;
  final DioException ? error;

  const DropsState({this.drops, this.userDrops, this.drop, this.newDrop, this.error});

  @override
  List<Object?> get props => [drops, error];
}

class DropsLoading extends DropsState {
  const DropsLoading(List<DropEntity> drop) : super(drops: drop);
}
class DropsDone extends DropsState {
  const DropsDone(List<DropEntity> drop) : super(drops: drop);
}
class DropsError extends DropsState {
  const DropsError(
    DioException error,
    List<DropEntity> drop
  ) : super(
    error: error,
    drops: drop
  );
}


class DropLoading extends DropsState {
  const DropLoading();
}
class DropDone extends DropsState {
  const DropDone(DropEntity drop) : super(drop: drop);
}
class DropError extends DropsState {
  const DropError(DioException error) : super(error: error);
}


class UserDropsLoading extends DropsState {
  const UserDropsLoading();
}
class UserDropsDone extends DropsState {
  const UserDropsDone(List<DropEntity> userDrops) : super(userDrops: userDrops);
}
class UserDropsError extends DropsState {
  const UserDropsError(DioException error) : super(error: error);
}

class PostDropLoading extends DropsState {
  const PostDropLoading();
}
class PostDropDone extends DropsState {
  const PostDropDone(DropEntity newDrop) : super(newDrop: newDrop);
}
class PostDropError extends DropsState {
  const PostDropError(DioException error) : super(error: error);
}

class FeedLoading extends DropsState {
  const FeedLoading();
}
class FeedDone extends DropsState {
  const FeedDone(List<DropEntity> drops) : super(drops: drops);
}
class FeedError extends DropsState {
  const FeedError(DioException error) : super(error: error);
}