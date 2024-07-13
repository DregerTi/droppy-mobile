import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../data/models/drop.dart';
import 'feed_event.dart';
import 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final WebSocketChannel _channel;

  FeedBloc(this._channel) : super(WebSocketInitial()) {
    _channel.stream.listen((data) {
      add(WebSocketMessageReceived(data));
    });

    on<WebSocketSendMessage>((event, emit) {
      _channel.sink.add(event.message);
    });

    on<WebSocketMessageReceived>((event, emit) {
      final data = jsonDecode(event.message);
      print(data);
      final List<DropModel> drops = data.map<DropModel>((dynamic i) => DropModel.fromJson(i as Map<String, dynamic>)).toList();

      emit(WebSocketMessageState(drops));
    });

    on<WebSocketDisconnect>((event, emit) {
      _channel.sink.close();
      emit(WebSocketDisconnected());
    });
  }

  @override
  Future<void> close() {
    _channel.sink.close();
    return super.close();
  }
}
