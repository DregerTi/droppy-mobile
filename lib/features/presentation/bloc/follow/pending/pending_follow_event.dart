import 'package:equatable/equatable.dart';

abstract class PendingFollowEvent extends Equatable {
  const PendingFollowEvent();

  @override
  List<Object> get props => [];
}

class PendingFollowWebSocketReconnect extends PendingFollowEvent {}

class PendingFollowWebSocketConnect extends PendingFollowEvent {}

class PendingFollowWebSocketSendMessage extends PendingFollowEvent {
  final String message;

  const PendingFollowWebSocketSendMessage(this.message);

  @override
  List<Object> get props => [message];
}

class PendingFollowWebSocketMessageReceived extends PendingFollowEvent {
  final String message;

  const PendingFollowWebSocketMessageReceived(this.message);

  @override
  List<Object> get props => [message];
}

class PendingFollowWebSocketDisconnect extends PendingFollowEvent {}
