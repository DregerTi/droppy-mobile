import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/content.dart';

abstract class ContentState extends Equatable {
  final List<ContentEntity?> ? contents;
  final DioException ? error;

  const ContentState({this.contents,this.error});

  @override
  List<Object?> get props => [contents, error];
}

class ContentInit extends ContentState {
  const ContentInit();
}

class SearchContentLoading extends ContentState {
  const SearchContentLoading();
}
class SearchContentDone extends ContentState {
  const SearchContentDone(List<ContentEntity?>? contents) : super(contents: contents);
}
class SearchContentError extends ContentState {
  const SearchContentError(
    DioException error
  ) : super(
    error: error
  );
}
