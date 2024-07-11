import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import '../../../../domain/entities/user.dart';

abstract class FollowGetState extends Equatable {
  final List<UserEntity?>? users;
  final DioException ? error;
  final UserEntity ? me;

  const FollowGetState({this.users, this.error, this.me});

  @override
  List<Object?> get props => [users, error];
  Object? get prop => users;
}

class FollowGetInit extends FollowGetState {
  const FollowGetInit();
}

class FollowersLoading extends FollowGetState {
  const FollowersLoading();
}
class FollowersDone extends FollowGetState {
  const FollowersDone(List<UserEntity?>? users) : super(users: users);
}
class FollowersError extends FollowGetState {
  const FollowersError(DioException error) : super(error: error);
}

class FollowedLoading extends FollowGetState {
  const FollowedLoading();
}
class FollowedDone extends FollowGetState {
  const FollowedDone(List<UserEntity?>? users) : super(users: users);
}
class FollowedError extends FollowGetState {
  const FollowedError(DioException error) : super(error: error);
}
