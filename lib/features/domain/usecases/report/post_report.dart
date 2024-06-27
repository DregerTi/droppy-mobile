import '../../../../core/ressources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../data/models/report.dart';
import '../../repository/report_repository.dart';

class PostReportUseCase implements UseCase<DataState<ReportModel>, Map<String, dynamic>> {
  final ReportRepository _reportRepository;

  PostReportUseCase(this._reportRepository);

  @override
  Future<DataState<ReportModel>> call({Map<String, dynamic>? params}) async {
    return _reportRepository.postReport(params!);
  }
}
