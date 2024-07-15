import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/ressources/data_state.dart';
import '../../../domain/usecases/content/search_content.dart';
import 'content_event.dart';
import 'content_state.dart';

class ContentBloc extends Bloc<ContentEvent, ContentState> {
  
  final SearchContentUseCase _searchContentUseCase;

  ContentBloc(
      this._searchContentUseCase,
  ) : super(
      const ContentInit()
  ){
    on <SearchContent> (onSearchContent);
  }
  
  void onSearchContent(SearchContent event, Emitter<ContentState> emit) async {
    emit(
      const SearchContentLoading()
    );

    final dataState = await _searchContentUseCase(params: event.params);

    if(dataState is DataSuccess){
      emit(
        SearchContentDone(dataState.data)
      );
    }

    if(dataState is DataFailed){
      emit(
        SearchContentError(dataState.error!)
      );
    }
  }
}