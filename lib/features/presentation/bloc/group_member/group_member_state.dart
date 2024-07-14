import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/group_member.dart';

abstract class GroupMembersState extends Equatable {
  final GroupMemberEntity ? groupMember;
  final DioException ? error;

  const GroupMembersState({this.groupMember, this.error});

  @override
  List<Object?> get props => [groupMember, error];
}


class LeaveGroupLoading extends GroupMembersState {
  const LeaveGroupLoading();
}
class LeaveGroupDone extends GroupMembersState {
  const LeaveGroupDone(GroupMemberEntity groupMember) : super(groupMember: groupMember);
}
class LeaveGroupError extends GroupMembersState {
  const LeaveGroupError(DioException error) : super(error: error);
}


class PostGroupJoinLoading extends GroupMembersState {
  const PostGroupJoinLoading();
}
class PostGroupJoinDone extends GroupMembersState {
  const PostGroupJoinDone(GroupMemberEntity groupMember) : super(groupMember: groupMember);
}
class PostGroupJoinError extends GroupMembersState {
  const PostGroupJoinError(DioException error) : super(error: error);
}