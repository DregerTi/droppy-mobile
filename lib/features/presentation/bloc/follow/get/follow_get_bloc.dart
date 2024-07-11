import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/ressources/data_state.dart';
import '../../../../domain/usecases/user/get_users_followed.dart';
import '../../../../domain/usecases/user/get_users_followers.dart';
import 'follow_get_event.dart';
import 'follow_get_state.dart';

class FollowGetBloc extends Bloc<FollowGetEvent, FollowGetState> {

  final GetUserFollowersUseCase _getUserFollowersUseCase;
  final GetUserFollowedUseCase _getUserFollowedUseCase;

  FollowGetBloc(
    this._getUserFollowersUseCase,
    this._getUserFollowedUseCase,
  ) : super(const FollowGetInit()){
    on <GetUserFollowers> (onGetUserFollowers);
    on <GetUserFollowed> (onGetUserFollowed);
  }

  void onGetUserFollowers(GetUserFollowers event, Emitter<FollowGetState> emit) async {
    emit(
      const FollowersLoading()
    );

    final dataState = await _getUserFollowersUseCase(params: event.params);

    if(dataState is DataSuccess ){
      emit(
        FollowersDone(dataState.data)
      );
    }

    if(dataState is DataFailed){
      emit(
        FollowersError(dataState.error!)
      );
    }
  }

  void onGetUserFollowed(GetUserFollowed event, Emitter<FollowGetState> emit) async {
    emit(
      const FollowedLoading()
    );

    final dataState = await _getUserFollowedUseCase(params: event.params);

    if(dataState is DataSuccess ){
      emit(
        FollowedDone(dataState.data)
      );
    }

    if(dataState is DataFailed){
      emit(
        FollowedError(dataState.error!)
      );
    }
  }
}