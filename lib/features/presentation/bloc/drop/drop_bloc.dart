import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/ressources/data_state.dart';
import '../../../data/models/drop.dart';
import '../../../data/models/like.dart';
import '../../../domain/entities/drop.dart';
import '../../../domain/usecases/drop/get_drop.dart';
import '../../../domain/usecases/drop/get_drops.dart';
import '../../../domain/usecases/drop/get_user_drops.dart';
import '../../../domain/usecases/drop/post_drop.dart';
import 'drop_event.dart';
import 'drop_state.dart';

class DropsBloc extends Bloc<DropsEvent, DropsState> {
  
  final GetDropsUseCase _getDropsUseCase;
  final GetDropUseCase _getDropUseCase;
  final GetUserDropsUseCase _getUserDropsUseCase;
  final PostDropUseCase _postDropUseCase;

  List<DropEntity>? _lastDrops;
  DropEntity? _lastDrop;

  DropsBloc(
      this._getDropsUseCase,
      this._getDropUseCase,
      this._getUserDropsUseCase,
      this._postDropUseCase
  ) : super(
      const DropsLoading([])
  ){
    on <GetDrops> (onGetDrops);
    on <GetDrop> (onGetDrop);
    on <GetUserDrops> (onGetUserDrops);
    on <PostDrop> (onPostDrop);
    on <UpdateLoadedDropsCurrentUserLike> (onUpdateLoadedDropsCurrentUserLike);
  }
  
  void onGetDrops(GetDrops event, Emitter<DropsState> emit) async {
    final currentDrops = _lastDrops ?? [];
    emit(
      DropsLoading(
        currentDrops
      )
    );

    final dataState = await _getDropsUseCase(params: event.params);

    if(dataState is DataSuccess && dataState.data!.isNotEmpty){
      _lastDrops = dataState.data;
      emit(
        DropsDone(dataState.data!)
      );
    }

    if(dataState is DataFailed){
      emit(
        DropsError(dataState.error!, currentDrops)
      );
    }
  }

  void onGetDrop(GetDrop event, Emitter<DropsState> emit) async {
    emit(
      const DropLoading()
    );
    final dataState = await _getDropUseCase(params: event.params);

    if(dataState is DataSuccess){
      _lastDrop = dataState.data;
      emit(
        DropDone(dataState.data!)
      );
    }

    if(dataState is DataFailed){
      emit(
        DropError(dataState.error!)
      );
    }
  }

  void onGetUserDrops(GetUserDrops event, Emitter<DropsState> emit) async {
    emit(
      const UserDropsLoading()
    );
    final dataState = await _getUserDropsUseCase(params: event.params);
    if(dataState is DataSuccess){
      emit(
          UserDropsDone(dataState.data!)
      );
    }

    if(dataState is DataFailed){
      emit(
          UserDropsError(dataState.error!)
      );
    }
  }

  void onPostDrop(PostDrop event, Emitter<DropsState> emit) async {
    emit(
      const PostDropLoading()
    );
    final dataState = await _postDropUseCase(params: event.params);

    if(dataState is DataSuccess){
      emit(
        PostDropDone(dataState.data!)
      );
    }

    if(dataState is DataFailed){
      emit(
        PostDropError(dataState.error!)
      );
    }
  }

  void onUpdateLoadedDropsCurrentUserLike(UpdateLoadedDropsCurrentUserLike event, Emitter<DropsState> emit) async {
    final LikeModel like = event.params['like'] as LikeModel;

    final int? dropIndex = _lastDrops?.indexWhere((drop) => drop.iri == like.dropIri);
    if (dropIndex != null && dropIndex != -1) {
      DropModel updatedDrop = DropModel(
        id: _lastDrops?[dropIndex].id,
        iri: _lastDrops?[dropIndex].iri,
        description: _lastDrops?[dropIndex].description,
        
      );
      _lastDrops?[dropIndex] = updatedDrop;
      emit(
        DropsDone(_lastDrops!),
      );
    }

    if(_lastDrop?.iri == like.dropIri){
      DropEntity drop = DropEntity(
        id: _lastDrop?.id,
        iri: _lastDrop?.iri,
        description: _lastDrop?.description,
        
      );

      _lastDrop = drop;
      emit(
        DropDone(_lastDrop!),
      );
    }
  }
}