import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../../../core/constants/constants.dart';
import 'has_dropped_event.dart';
import 'has_dropped_state.dart';

class HasDroppedBloc extends Bloc<HasDroppedEvent, HasDroppedState> {
  late final WebSocketChannel _channel;
  final int _reconnectDelay = 5;
  bool retry = true;

  HasDroppedBloc() : super(HasDroppedWebSocketInitial()) {
    on <HasDroppedWebSocketConnect>(onHasDroppedWebSocketConnect);
    on <HasDroppedWebSocketReconnect>(onHasDroppedWebSocketReconnect);
    on <HasDroppedWebSocketSendMessage>(onHasDroppedWebSocketSendMessage);
    on <HasDroppedWebSocketMessageReceived>(onHasDroppedWebSocketMessageReceived);
    on <HasDroppedWebSocketDisconnect>(onHasDroppedWebSocketDisconnect);
  }

  void onHasDroppedWebSocketConnect(HasDroppedWebSocketConnect event, Emitter<HasDroppedState> emit) async {
    await _connectWebSocket(emit);
  }

  Future<void> _connectWebSocket(Emitter<HasDroppedState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');

    _channel = IOWebSocketChannel.connect(
        Uri.parse('$wsBaseUrl/drops/has-user-dropped'),headers: {
      'Authorization': 'Bearer $jwtToken'
    });

    _channel.stream.listen(
          (data) {
        add(HasDroppedWebSocketMessageReceived(data));
      },
      onDone: () {
        add(HasDroppedWebSocketReconnect());
      },
      onError: (error) {
        add(HasDroppedWebSocketReconnect());
      },
    );
  }

  void onHasDroppedWebSocketReconnect(HasDroppedWebSocketReconnect event, Emitter<HasDroppedState> emit) {
    if(retry == true) {
      emit(HasDroppedWebSocketReconnecting());
      Timer(Duration(seconds: _reconnectDelay), () {
        add(HasDroppedWebSocketConnect());
      });
    }
    retry = true;
  }

  void onHasDroppedWebSocketSendMessage(HasDroppedWebSocketSendMessage event, Emitter<HasDroppedState> emit) {
    _channel.sink.add(event.message);
  }

  void onHasDroppedWebSocketMessageReceived(HasDroppedWebSocketMessageReceived event, Emitter<HasDroppedState> emit) {
    final data = jsonDecode(event.message);
    bool hasDropped = data['status'];
    emit(HasDroppedWebSocketMessageLoadingReceived(hasDropped));
    emit(HasDroppedWebSocketMessageState(hasDropped));
  }

  void onHasDroppedWebSocketDisconnect(HasDroppedWebSocketDisconnect event, Emitter<HasDroppedState> emit) {
    retry = false;
    _channel.sink.close();
    print('hasDropedClose');
    print(_channel.closeReason);
    emit(HasDroppedWebSocketDisconnected());
  }

  @override
  Future<void> close() {
    _channel.sink.close();
    return super.close();
  }
}
