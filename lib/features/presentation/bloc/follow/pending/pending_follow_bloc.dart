import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../data/models/follow.dart';
import 'pending_follow_event.dart';
import 'pending_follow_state.dart';

class PendingFollowBloc extends Bloc<PendingFollowEvent, PendingFollowState> {
  late final WebSocketChannel _channel;

  PendingFollowBloc() : super(WebSocketInitial()) {
    on <WebSocketConnect>(onWebSocketConnect);
  }

  void onWebSocketConnect(WebSocketConnect event, Emitter<PendingFollowState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');

    _channel = IOWebSocketChannel.connect(
        Uri.parse('$wsBaseUrl/follows/pending/ws'),headers: {
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
      final List<FollowModel> drops = data.map<FollowModel>((dynamic i) => FollowModel.fromJson(i as Map<String, dynamic>)).toList();

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
