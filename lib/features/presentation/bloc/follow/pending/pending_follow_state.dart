import 'package:equatable/equatable.dart';
import '../../../../domain/entities/follow.dart';

abstract class PendingFollowState extends Equatable {
  final List<FollowEntity> ? drops;

  const PendingFollowState({this.drops});

  @override
  List<Object> get props => [];
}

class WebSocketInitial extends PendingFollowState {}

class WebSocketMessageState extends PendingFollowState {

  const WebSocketMessageState(List<FollowEntity> drops) : super(drops: drops);
}

class WebSocketDisconnected extends PendingFollowState {}
