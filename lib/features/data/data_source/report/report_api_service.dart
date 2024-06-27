import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/constants/constants.dart';
import '../../models/report.dart';

part 'report_api_service.g.dart';

@RestApi(baseUrl:baseUrl)
abstract class ReportApiService {
  factory ReportApiService(Dio dio) = _ReportApiService;

  @POST("/reports")
  Future<HttpResponse<ReportModel>> postReport(
    @Body() Map<String, dynamic> report,
  );
}