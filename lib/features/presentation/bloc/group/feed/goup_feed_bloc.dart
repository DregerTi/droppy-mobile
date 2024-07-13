import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/ressources/data_state.dart';
import '../../../../domain/usecases/group/get_group_feed.dart';
import 'group_feed_event.dart';
import 'group_feed_state.dart';

class GroupFeedBloc extends Bloc<GroupFeedEvent, GroupFeedState> {
  
  final GetGroupFeedUseCase _getGroupFeedUseCase;

  GroupFeedBloc(
      this._getGroupFeedUseCase,
  ) : super(
      const GroupFeedInit()
  ){
    on <GetGroupFeed> (onGetGroupFeed);
  }
  
  void onGetGroupFeed(GetGroupFeed event, Emitter<GroupFeedState> emit) async {
    emit(
      const GroupFeedLoading()
    );

    final dataState = await _getGroupFeedUseCase(params: event.params);

    if(dataState is DataSuccess){
      emit(
        GroupFeedDone(dataState.data)
      );
    }

    if(dataState is DataFailed){
      emit(
        GroupFeedError(dataState.error!)
      );
    }
  }

}