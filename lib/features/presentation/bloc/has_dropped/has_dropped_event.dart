import 'package:equatable/equatable.dart';

abstract class HasDroppedEvent extends Equatable {
  const HasDroppedEvent();

  @override
  List<Object> get props => [];
}

class HasDroppedWebSocketConnect extends HasDroppedEvent {}

class HasDroppedWebSocketSendMessage extends HasDroppedEvent {
  final String message;

  const HasDroppedWebSocketSendMessage(this.message);

  @override
  List<Object> get props => [message];
}

class HasDroppedWebSocketMessageReceived extends HasDroppedEvent {
  final String message;

  const HasDroppedWebSocketMessageReceived(this.message);

  @override
  List<Object> get props => [message];
}

class HasDroppedWebSocketDisconnect extends HasDroppedEvent {}
