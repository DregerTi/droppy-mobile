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

  PendingFollowBloc() : super(PendingFollowWebSocketInitial()) {
    on <PendingFollowWebSocketConnect>(onPendingFollowWebSocketConnect);
  }

  void onPendingFollowWebSocketConnect(PendingFollowWebSocketConnect event, Emitter<PendingFollowState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');

    _channel = IOWebSocketChannel.connect(
        Uri.parse('$wsBaseUrl/follows/pending'),headers: {
      'Authorization': 'Bearer $jwtToken'
    });

    _channel.stream.listen((data) {
      add(PendingFollowWebSocketMessageReceived(data));
    });

    on<PendingFollowWebSocketSendMessage>((event, emit) {
      _channel.sink.add(event.message);
    });

    on<PendingFollowWebSocketMessageReceived>((event, emit) {
      final data = jsonDecode(event.message);
      List<FollowModel> follows = [];

      if(data is List) {
        follows = data.map<FollowModel>((dynamic i) => FollowModel.fromJson(i as Map<String, dynamic>)).toList();
      }
      emit(PendingFollowWebSocketMessageLoadingReceived(follows));
      emit(PendingFollowWebSocketMessageState(follows));
    });

    on<PendingFollowWebSocketDisconnect>((event, emit) {
      _channel.sink.close();
      emit(PendingFollowWebSocketDisconnected());
    });
  }

  @override
  Future<void> close() {
    _channel.sink.close();
    return super.close();
  }
}
