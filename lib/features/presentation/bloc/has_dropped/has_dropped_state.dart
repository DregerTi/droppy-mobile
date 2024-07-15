import 'package:equatable/equatable.dart';

abstract class HasDroppedState extends Equatable {
  final bool ? hasDropped;

  const HasDroppedState({this.hasDropped});

  @override
  List<Object> get props => [];
}

class HasDroppedWebSocketInitial extends HasDroppedState {}

class HasDroppedWebSocketMessageState extends HasDroppedState {

  const HasDroppedWebSocketMessageState(bool hasDropped) : super(hasDropped: hasDropped);
}

class HasDroppedWebSocketMessageLoadingReceived extends HasDroppedState {
  const HasDroppedWebSocketMessageLoadingReceived(bool hasDropped): super(hasDropped: hasDropped);
}

class HasDroppedWebSocketDisconnected extends HasDroppedState {}
