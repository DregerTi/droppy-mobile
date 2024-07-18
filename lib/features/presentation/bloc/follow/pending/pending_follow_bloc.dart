import 'dart:async';
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
  final int _reconnectDelay = 5;
  bool retry = true;

  PendingFollowBloc() : super(PendingFollowWebSocketInitial()) {
    on <PendingFollowWebSocketConnect>(onPendingFollowWebSocketConnect);
    on <PendingFollowWebSocketReconnect>(onPendingFollowWebSocketReconnect);
    on <PendingFollowWebSocketSendMessage>(onPendingFollowWebSocketSendMessage);
    on <PendingFollowWebSocketMessageReceived>(onPendingFollowWebSocketMessageReceived);
    on <PendingFollowWebSocketDisconnect>(onPendingFollowWebSocketDisconnect);
  }

  void onPendingFollowWebSocketConnect(PendingFollowWebSocketConnect event, Emitter<PendingFollowState> emit) async {
    await _connectWebSocket(emit);
  }

  Future<void> _connectWebSocket(Emitter<PendingFollowState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');

    _channel = IOWebSocketChannel.connect(
        Uri.parse('$wsBaseUrl/follows/pending'),headers: {
      'Authorization': 'Bearer $jwtToken'
    });

    _channel.stream.listen(
          (data) {
        add(PendingFollowWebSocketMessageReceived(data));
      },
      onDone: () {
        add(PendingFollowWebSocketReconnect());
      },
      onError: (error) {
        add(PendingFollowWebSocketReconnect());
      },
    );
  }

  void onPendingFollowWebSocketReconnect(PendingFollowWebSocketReconnect event, Emitter<PendingFollowState> emit) {
    if(retry == true) {
      emit(PendingFollowWebSocketReconnecting());
      Timer(Duration(seconds: _reconnectDelay), () {
        add(PendingFollowWebSocketConnect());
      });
    }
    retry = true;
  }

  void onPendingFollowWebSocketSendMessage(PendingFollowWebSocketSendMessage event, Emitter<PendingFollowState> emit) {
    _channel.sink.add(event.message);
  }

  void onPendingFollowWebSocketMessageReceived(PendingFollowWebSocketMessageReceived event, Emitter<PendingFollowState> emit) {
    final data = jsonDecode(event.message);
    List<FollowModel> follows = [];

    if(data is List) {
      follows = data.map<FollowModel>((dynamic i) => FollowModel.fromJson(i as Map<String, dynamic>)).toList();
    }

    emit(PendingFollowWebSocketMessageLoadingReceived(follows));
    emit(PendingFollowWebSocketMessageState(follows));
  }

  void onPendingFollowWebSocketDisconnect(PendingFollowWebSocketDisconnect event, Emitter<PendingFollowState> emit) {
    retry = false;
    _channel.sink.close();
    emit(PendingFollowWebSocketDisconnected());
  }

  @override
  Future<void> close() {
    _channel.sink.close();
    return super.close();
  }
}
