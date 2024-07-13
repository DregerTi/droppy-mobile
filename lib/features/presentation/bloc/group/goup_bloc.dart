import 'package:droppy/features/domain/usecases/group/patch_group.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/ressources/data_state.dart';
import '../../../domain/usecases/group/get_group.dart';
import '../../../domain/usecases/group/get_groups.dart';
import '../../../domain/usecases/group/post_group.dart';
import 'group_event.dart';
import 'group_state.dart';

class GroupsBloc extends Bloc<GroupsEvent, GroupsState> {
  
  final GetGroupsUseCase _getGroupsUseCase;
  final GetGroupUseCase _getGroupUseCase;
  final PostGroupUseCase _postGroupUseCase;
  final PatchGroupUseCase _patchGroupUseCase;

  GroupsBloc(
      this._getGroupsUseCase,
      this._getGroupUseCase,
      this._postGroupUseCase,
      this._patchGroupUseCase
  ) : super(
      const GroupsInit()
  ){
    on <GetGroups> (onGetGroups);
    on <GetGroup> (onGetGroup);
    on <PostGroup> (onPostGroup);
    on <PatchGroup> (onPatchGroup);
  }
  
  void onGetGroups(GetGroups event, Emitter<GroupsState> emit) async {
    emit(
      const GroupsLoading()
    );

    final dataState = await _getGroupsUseCase(params: event.params);

    if(dataState is DataSuccess){
      emit(
        GroupsDone(dataState.data)
      );
    }

    if(dataState is DataFailed){
      emit(
        GroupsError(dataState.error!)
      );
    }
  }

  void onGetGroup(GetGroup event, Emitter<GroupsState> emit) async {
    emit(
      const GroupLoading()
    );
    final dataState = await _getGroupUseCase(params: event.params);

    if(dataState is DataSuccess){
      emit(
        GroupDone(dataState.data!)
      );
    }

    if(dataState is DataFailed){
      emit(
        GroupError(dataState.error!)
      );
    }
  }

  void onPostGroup(PostGroup event, Emitter<GroupsState> emit) async {
    emit(
      const PostGroupLoading()
    );
    final dataState = await _postGroupUseCase(params: event.params);

    if(dataState is DataSuccess){
      emit(
        PostGroupDone(dataState.data!)
      );
    }

    if(dataState is DataFailed){
      emit(
        PostGroupError(dataState.error!)
      );
    }
  }

void onPatchGroup(PatchGroup event, Emitter<GroupsState> emit) async {
    emit(
      const PatchGroupLoading()
    );
    final dataState = await _patchGroupUseCase(params: event.params);

    if(dataState is DataSuccess){
      emit(
        PatchGroupDone(dataState.data!)
      );
    }

    if(dataState is DataFailed){
      emit(
        PatchGroupError(dataState.error!)
      );
    }
  }
}