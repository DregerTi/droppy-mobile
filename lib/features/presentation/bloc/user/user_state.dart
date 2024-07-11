import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.dart';

abstract class UsersState extends Equatable {
  final List<UserEntity?>? users;
  final UserEntity ? user;
  final DioException ? error;
  final UserEntity ? me;

  const UsersState({this.users, this.user, this.error, this.me});

  @override
  List<Object?> get props => [users, error];
  Object? get prop => users;
}

class UsersInit extends UsersState {
  const UsersInit();
}

class UsersSearchLoading extends UsersState {
  const UsersSearchLoading();
}
class UsersSearchDone extends UsersState {
  const UsersSearchDone(List<UserEntity?>? user) : super(users: user);
}
class UsersSearchError extends UsersState {
  const UsersSearchError(DioException error) : super(error: error);
}

class UserLoading extends UsersState {
  const UserLoading();
}
class UserDone extends UsersState {
  const UserDone(UserEntity user) : super(user: user);
}
class UserError extends UsersState {
  const UserError(DioException error) : super(error: error);
}

class MeLoading extends UsersState {
  const MeLoading();
}
class MeDone extends UsersState {
  const MeDone(UserEntity me) : super(me: me);
}
class MeError extends UsersState {
  const MeError(DioException error) : super(error: error);
}

class PostUserLoading extends UsersState {
  const PostUserLoading();
}
class PostUserDone extends UsersState {
  const PostUserDone(UserEntity user) : super(user: user);
}
class PostUserError extends UsersState {
  const PostUserError(DioException error) : super(error: error);
}

class PatchUserLoading extends UsersState {
  const PatchUserLoading();
}
class PatchUserDone extends UsersState {
  const PatchUserDone(UserEntity user) : super(user: user);
}
class PatchUserError extends UsersState {
  const PatchUserError(DioException error) : super(error: error);
}

