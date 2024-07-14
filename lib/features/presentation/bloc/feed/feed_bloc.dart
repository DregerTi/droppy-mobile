import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../../core/constants/constants.dart';
import '../../../data/models/drop.dart';
import 'feed_event.dart';
import 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  late final WebSocketChannel _channel;

  FeedBloc() : super(WebSocketInitial()) {
    on <WebSocketConnect>(onWebSocketConnect);
  }

  void onWebSocketConnect(WebSocketConnect event, Emitter<FeedState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');

    _channel = IOWebSocketChannel.connect(
        Uri.parse('$wsBaseUrl/users/my-feed/ws'),headers: {
      'Authorization': 'Bearer $jwtToken'
    });

    _channel.stream.listen((data) {
      add(WebSocketMessageReceived(data));
    });

    on<WebSocketSendMessage>((event, emit) {
      _channel.sink.add(event.message);
    });

    on<WebSocketMessageReceived>((event, emit) {
      final data = jsonDecode(event.message);
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
