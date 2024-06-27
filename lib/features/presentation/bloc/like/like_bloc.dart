import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ressources/data_state.dart';
import '../../../domain/usecases/like/delete_like.dart';
import '../../../domain/usecases/like/get_user_like.dart';
import '../../../domain/usecases/like/post_like.dart';
import 'like_event.dart';
import 'like_state.dart';

class LikesBloc extends Bloc<LikesEvent, LikesState> {
  
  final GetUserLikesUseCase _getUserLikes;
  final PostLikeUseCase _postLike;
  final DeleteLikeUseCase _deleteLike;

  LikesBloc(
      this._getUserLikes,
      this._postLike,
      this._deleteLike
  ) : super(
      const LikesLoading()
  ){
    on <GetUserLikes> (onGetUserLikes);
    on <PostLike> (onPostLike);
    on <DeleteLike> (onDeleteLike);
  }
  
  void onGetUserLikes(GetUserLikes event, Emitter<LikesState> emit) async {
    emit(
      const LikesLoading()
    );
    final dataState = await _getUserLikes(params: event.params);

    if(dataState is DataSuccess && dataState.data!.isNotEmpty){
      emit(
        LikesDone(dataState.data!)
      );
    }

    if(dataState is DataFailed){
      emit(
        LikesError(dataState.error!)
      );
    }
  }

  void onPostLike(PostLike event, Emitter<LikesState> emit) async {
    emit(
      const PostLikeLoading()
    );
    final dataState = await _postLike(params: event.params);

    if(dataState is DataSuccess){
      emit(
        PostLikeDone(dataState.data!)
      );
    }

    if(dataState is DataFailed){
      emit(
        PostLikeError(dataState.error!)
      );
    }
  }

  void onDeleteLike(DeleteLike event, Emitter<LikesState> emit) async {
    emit(
      const DeleteLikeLoading()
    );
    final dataState = await _deleteLike(params: event.params);

    if(dataState is DataSuccess){
      emit(
        const DeleteLikeDone()
      );
    }

    if(dataState is DataFailed){
      emit(
        DeleteLikeError(dataState.error!)
      );
    }
  }
  
}