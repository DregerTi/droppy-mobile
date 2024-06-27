import '../../../core/ressources/data_state.dart';
import '../../data/models/report.dart';

abstract class ReportRepository {

  Future<DataState<ReportModel>> postReport(Map<String, dynamic> report);

}