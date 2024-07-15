import 'package:equatable/equatable.dart';
import '../../../../domain/entities/follow.dart';

abstract class PendingFollowState extends Equatable {
  final List<FollowEntity> ? follows;

  const PendingFollowState({this.follows});

  @override
  List<Object> get props => [];
}

class PendingFollowWebSocketInitial extends PendingFollowState {}

class PendingFollowWebSocketMessageState extends PendingFollowState {

  const PendingFollowWebSocketMessageState(List<FollowEntity> follows) : super(follows: follows);
}

class PendingFollowWebSocketMessageLoadingReceived extends PendingFollowState {
  const PendingFollowWebSocketMessageLoadingReceived(List<FollowEntity> follows): super(follows: follows);
}

class PendingFollowWebSocketDisconnected extends PendingFollowState {}
