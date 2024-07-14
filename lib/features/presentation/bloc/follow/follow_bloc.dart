import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/ressources/data_state.dart';
import '../../../domain/usecases/follow/accept_follow.dart';
import '../../../domain/usecases/follow/delete_follow.dart';
import '../../../domain/usecases/follow/post_follow.dart';
import '../../../domain/usecases/follow/refuse_follow.dart';
import 'follow_event.dart';
import 'follow_state.dart';

class FollowsBloc extends Bloc<FollowsEvent, FollowsState> {
  final PostFollowUseCase _postFollow;
  final DeleteFollowUseCase _deleteFollow;
  final AcceptFollowUseCase _acceptFollow;
  final RefuseFollowUseCase _refuseFollow;

  FollowsBloc(
      this._postFollow,
      this._deleteFollow,
      this._acceptFollow,
      this._refuseFollow
  ) : super(
      const FollowsInitial()
  ){
    on <PostFollow> (onPostFollow);
    on <DeleteFollow> (onDeleteFollow);
    on <AcceptFollow> (onAcceptFollow);
    on <RefuseFollow> (onRefuseFollow);
  }

  void onPostFollow(PostFollow event, Emitter<FollowsState> emit) async {
    emit(
      const PostFollowLoading()
    );
    final dataState = await _postFollow(params: event.params);

    if(dataState is DataSuccess){
      emit(
        PostFollowDone(dataState.data)
      );
    }

    if(dataState is DataFailed){
      emit(
        PostFollowError(dataState.error!)
      );
    }
  }

  void onDeleteFollow(DeleteFollow event, Emitter<FollowsState> emit) async {
    emit(
      const DeleteFollowLoading()
    );
    final dataState = await _deleteFollow(params: event.params);

    if(dataState is DataSuccess){
      emit(
        const DeleteFollowDone()
      );
    }

    if(dataState is DataFailed){
      emit(
        DeleteFollowError(dataState.error!)
      );
    }
  }

  void onAcceptFollow(AcceptFollow event, Emitter<FollowsState> emit) async {
    emit(
      const AcceptFollowLoading()
    );
    final dataState = await _acceptFollow(params: event.params);

    if(dataState is DataSuccess){
      emit(
        AcceptFollowDone(dataState.data)
      );
    }

    if(dataState is DataFailed){
      emit(
        AcceptFollowError(dataState.error!)
      );
    }
  }

  void onRefuseFollow(RefuseFollow event, Emitter<FollowsState> emit) async {
    emit(
      const RefuseFollowLoading()
    );
    final dataState = await _refuseFollow(params: event.params);

    if(dataState is DataSuccess){
      emit(
        const RefuseFollowDone()
      );
    }

    if(dataState is DataFailed){
      emit(
        RefuseFollowError(dataState.error!)
      );
    }
  }
  
}