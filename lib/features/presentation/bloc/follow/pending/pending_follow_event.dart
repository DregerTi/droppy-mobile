import 'package:equatable/equatable.dart';

abstract class PendingFollowEvent extends Equatable {
  const PendingFollowEvent();

  @override
  List<Object> get props => [];
}

class WebSocketConnect extends PendingFollowEvent {}

class WebSocketSendMessage extends PendingFollowEvent {
  final String message;

  const WebSocketSendMessage(this.message);

  @override
  List<Object> get props => [message];
}

class WebSocketMessageReceived extends PendingFollowEvent {
  final String message;

  const WebSocketMessageReceived(this.message);

  @override
  List<Object> get props => [message];
}

class WebSocketDisconnect extends PendingFollowEvent {}
