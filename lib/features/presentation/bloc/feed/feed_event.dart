import 'package:equatable/equatable.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object> get props => [];
}

class WebSocketSendMessage extends FeedEvent {
  final String message;

  const WebSocketSendMessage(this.message);

  @override
  List<Object> get props => [message];
}

class WebSocketMessageReceived extends FeedEvent {
  final String message;

  const WebSocketMessageReceived(this.message);

  @override
  List<Object> get props => [message];
}

class WebSocketDisconnect extends FeedEvent {}
