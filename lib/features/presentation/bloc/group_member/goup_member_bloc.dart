import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/ressources/data_state.dart';
import '../../../domain/usecases/group_member/leave_group.dart';
import '../../../domain/usecases/group_member/post_group_join.dart';
import 'group_member_state.dart';
import 'group_member_event.dart';

class GroupMembersBloc extends Bloc<GroupMembersEvent, GroupMembersState> {
  
  final LeaveGroupUseCase _leaveGroupUseCase;
  final PostGroupJoinUseCase _postGroupJoinUseCase;

  GroupMembersBloc(
      this._leaveGroupUseCase,
      this._postGroupJoinUseCase
  ) : super(
    const PostGroupJoinLoading()
  ){
    on <LeaveGroup> (onLeaveGroup);
    on <PostGroupJoin> (onPostGroupJoin);
  }

  void onLeaveGroup(LeaveGroup event, Emitter<GroupMembersState> emit) async {
    emit(
      const LeaveGroupLoading()
    );
    final dataState = await _leaveGroupUseCase(params: event.params);

    if(dataState is DataSuccess){
      emit(
        LeaveGroupDone(dataState.data!)
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
}