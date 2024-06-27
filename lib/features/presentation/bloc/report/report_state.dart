import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/report.dart';

abstract class ReportsState extends Equatable {
  final ReportEntity ? report;
  final DioException ? error;

  const ReportsState({this.report, this.error});

  @override
  List<Object?> get props => [report, error];
}

class PostReportInit extends ReportsState {
  const PostReportInit();
}

class PostReportLoading extends ReportsState {
  const PostReportLoading();
}
class PostReportDone extends ReportsState {
  const PostReportDone(ReportEntity report) : super(report: report);
}
class PostReportError extends ReportsState {
  const PostReportError(DioException error) : super(error: error);
}