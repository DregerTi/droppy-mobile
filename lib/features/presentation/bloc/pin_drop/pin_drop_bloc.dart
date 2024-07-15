import 'package:droppy/features/presentation/bloc/pin_drop/pin_drop_event.dart';
import 'package:droppy/features/presentation/bloc/pin_drop/pin_drop_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ressources/data_state.dart';
import '../../../domain/usecases/drop/patch_drop.dart';

class PinDropBloc extends Bloc<PinDropEvent, PinDropState> {
  final PatchDropUseCase _patchDropUseCase;

  PinDropBloc(
      this._patchDropUseCase,
  ) : super(
      const PinDropInitial()
  ){
    on <PostPinDrop> (onPostPinDrop);
    on <DeletePinDrop> (onDeletePinDrop);
  }

  void onPostPinDrop(PostPinDrop event, Emitter<PinDropState> emit) async {
    emit(
      const PostPinDropLoading()
    );
    final dataState = await _patchDropUseCase(
      params: {
        'id': event.params['id'],
        'drop': {
          'isPinned': true
        }
      }
    );

    if(dataState is DataSuccess){
      emit(
        PostPinDropDone(dataState.data)
      );
    }

    if(dataState is DataFailed){
      emit(
        PostPinDropError(dataState.error!)
      );
    }
  }

  void onDeletePinDrop(DeletePinDrop event, Emitter<PinDropState> emit) async {
    emit(
      const DeletePinDropLoading()
    );
    final dataState = await _patchDropUseCase(
        params: {
          'id': event.params['id'],
          'drop': {
            'isPinned': false
          }
        }
    );

    if(dataState is DataSuccess){
      emit(
        DeletePinDropDone(dataState.data)
      );
    }

    if(dataState is DataFailed){
      emit(
        DeletePinDropError(dataState.error!)
      );
    }
  }
  
}