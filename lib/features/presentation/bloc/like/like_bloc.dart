import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ressources/data_state.dart';
import '../../../domain/usecases/like/delete_like.dart';
import '../../../domain/usecases/like/post_like.dart';
import 'like_event.dart';
import 'like_state.dart';

class LikesBloc extends Bloc<LikesEvent, LikesState> {
  final PostLikeUseCase _postLike;
  final DeleteLikeUseCase _deleteLike;

  LikesBloc(
      this._postLike,
      this._deleteLike
  ) : super(
      const LikesInitial()
  ){
    on <PostLike> (onPostLike);
    on <DeleteLike> (onDeleteLike);
  }

  void onPostLike(PostLike event, Emitter<LikesState> emit) async {
    emit(
      const PostLikeLoading()
    );
    final dataState = await _postLike(params: event.params);

    if(dataState is DataSuccess){
      emit(
        PostLikeDone(dataState.data)
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