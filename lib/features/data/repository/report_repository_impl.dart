import 'dart:io';
import 'package:dio/dio.dart';
import '../../../core/ressources/data_state.dart';
import '../../domain/repository/report_repository.dart';
import '../data_source/report/report_api_service.dart';
import '../models/report.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportApiService _reportApiService;

  ReportRepositoryImpl(this._reportApiService);

  @override
  Future<DataState<ReportModel>> postReport(Map<String, dynamic> report) async {
    try {
      final httpResponse = await _reportApiService.postReport(report);

      if (httpResponse.response.statusCode == HttpStatus.created) {
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailed(
          DioException(
            error: httpResponse.response.statusMessage,
            response: httpResponse.response,
            type: DioExceptionType.unknown,
            requestOptions: httpResponse.response.requestOptions,
          ),
        );
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
}