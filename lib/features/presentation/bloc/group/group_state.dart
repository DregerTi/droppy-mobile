import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/group.dart';

abstract class GroupsState extends Equatable {
  final List<GroupEntity?> ? groups;
  final GroupEntity ? group;
  final GroupEntity ? newGroup;
  final DioException ? error;

  const GroupsState({this.groups, this.group, this.newGroup, this.error});

  @override
  List<Object?> get props => [groups, error];
}

class GroupsInit extends GroupsState {
  const GroupsInit();
}

class GroupsLoading extends GroupsState {
  const GroupsLoading();
}
class GroupsDone extends GroupsState {
  const GroupsDone(List<GroupEntity?>? group) : super(groups: group);
}
class GroupsError extends GroupsState {
  const GroupsError(
    DioException error
  ) : super(
    error: error
  );
}


class GroupLoading extends GroupsState {
  const GroupLoading();
}
class GroupDone extends GroupsState {
  const GroupDone(GroupEntity group) : super(group: group);
}
class GroupError extends GroupsState {
  const GroupError(DioException error) : super(error: error);
}


class PatchGroupLoading extends GroupsState {
  const PatchGroupLoading();
}
class PatchGroupDone extends GroupsState {
  const PatchGroupDone(GroupEntity group) : super(group: group);
}
class PatchGroupError extends GroupsState {
  const PatchGroupError(DioException error) : super(error: error);
}


class PostGroupLoading extends GroupsState {
  const PostGroupLoading();
}
class PostGroupDone extends GroupsState {
  const PostGroupDone(GroupEntity newGroup) : super(newGroup: newGroup);
}
class PostGroupError extends GroupsState {
  const PostGroupError(DioException error) : super(error: error);
}