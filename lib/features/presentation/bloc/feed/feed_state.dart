import 'package:equatable/equatable.dart';

import '../../../domain/entities/drop.dart';

abstract class FeedState extends Equatable {
  final List<DropEntity> ? drops;

  const FeedState({this.drops});

  @override
  List<Object> get props => [];
}

class WebSocketReconnecting extends FeedState {}

class WebSocketInitial extends FeedState {}

class WebSocketMessageState extends FeedState {
  const WebSocketMessageState(List<DropEntity> drops) : super(drops: drops);
}

class  WebSocketMessageLoadingReceived extends FeedState {
  const WebSocketMessageLoadingReceived(List<DropEntity> drops): super(drops: drops);
}

class WebSocketDisconnected extends FeedState {}
