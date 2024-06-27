import 'package:droppy/features/presentation/bloc/report/report_event.dart';
import 'package:droppy/features/presentation/bloc/report/report_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/ressources/data_state.dart';
import '../../../domain/usecases/report/post_report.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {

  final PostReportUseCase _postReportUseCase;

  ReportsBloc(
      this._postReportUseCase
  ) : super(
      const PostReportInit()
  ){
    on <PostReport> (onPostReport);
  }

  void onPostReport(PostReport event, Emitter<ReportsState> emit) async {
    emit(
        const PostReportLoading()
    );
    final dataState = await _postReportUseCase(params: event.params);

    if(dataState is DataSuccess){
      emit(
        PostReportDone(dataState.data!)
      );
    }

    if(dataState is DataFailed){
      emit(
        PostReportError(dataState.error!)
      );
    }
  }
  
}