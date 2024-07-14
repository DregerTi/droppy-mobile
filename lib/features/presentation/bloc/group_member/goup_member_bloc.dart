import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/ressources/data_state.dart';
import '../../../domain/usecases/group_member/leave_group.dart';
import '../../../domain/usecases/group_member/post_group_join.dart';
import '../../../domain/usecases/group_member/post_group_member.dart';
import 'group_member_state.dart';
import 'group_member_event.dart';

class GroupMembersBloc extends Bloc<GroupMembersEvent, GroupMembersState> {
  
  final LeaveGroupUseCase _leaveGroupUseCase;
  final PostGroupJoinUseCase _postGroupJoinUseCase;
  final PostGroupMemberUseCase _postGroupMemberUseCase;

  GroupMembersBloc(
      this._leaveGroupUseCase,
      this._postGroupJoinUseCase,
      this._postGroupMemberUseCase
  ) : super(
    const PostGroupJoinLoading()
  ){
    on <LeaveGroup> (onLeaveGroup);
    on <PostGroupJoin> (onPostGroupJoin);
    on <PostGroupMember> (onPostGroupMember);
  }

  void onLeaveGroup(LeaveGroup event, Emitter<GroupMembersState> emit) async {
    emit(
      const LeaveGroupLoading()
    );
    final dataState = await _leaveGroupUseCase(params: event.params);

    if(dataState is DataSuccess){
      emit(
        const LeaveGroupDone()
      );
    }

    if(dataState is DataFailed){
      emit(
        LeaveGroupError(dataState.error!)
      );
    }
  }

  void onPostGroupJoin(PostGroupJoin event, Emitter<GroupMembersState> emit) async {
    emit(
      const PostGroupJoinLoading()
    );
    final dataState = await _postGroupJoinUseCase(params: event.params);

    if(dataState is DataSuccess){
      emit(
        PostGroupJoinDone(dataState.data!)
      );
    }

    if(dataState is DataFailed){
      emit(
        PostGroupJoinError(dataState.error!)
      );
    }
  }

  void onPostGroupMember(PostGroupMember event, Emitter<GroupMembersState> emit) async {
    emit(
      const PostGroupMemberLoading()
    );
    final dataState = await _postGroupMemberUseCase(params: event.params);

    if(dataState is DataSuccess){
      emit(
        PostGroupMemberDone(dataState.data!)
      );
    }

    if(dataState is DataFailed){
      emit(
        PostGroupMemberError(dataState.error!)
      );
    }
  }
}