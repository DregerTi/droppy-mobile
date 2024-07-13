import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/entities/group.dart';

abstract class GroupFeedState extends Equatable {
  final GroupEntity ? group;
  final DioException ? error;

  const GroupFeedState({this.group, this.error});

  @override
  List<Object?> get props => [group, error];
}

class GroupFeedInit extends GroupFeedState {
  const GroupFeedInit();
}

class GroupFeedLoading extends GroupFeedState {
  const GroupFeedLoading();
}
class GroupFeedDone extends GroupFeedState {
  const GroupFeedDone(GroupEntity? group) : super(group: group);
}
class GroupFeedError extends GroupFeedState {
  const GroupFeedError(
    DioException error
  ) : super(
    error: error
  );
}
