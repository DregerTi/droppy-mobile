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

  HasDroppedBloc() : super(HasDroppedWebSocketInitial()) {
    on <HasDroppedWebSocketConnect>(onHasDroppedWebSocketConnect);
  }

  void onHasDroppedWebSocketConnect(HasDroppedWebSocketConnect event, Emitter<HasDroppedState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');

    _channel = IOWebSocketChannel.connect(
        Uri.parse('$wsBaseUrl/drops/has-user-dropped'),headers: {
      'Authorization': 'Bearer $jwtToken'
    });

    _channel.stream.listen((data) {
      add(HasDroppedWebSocketMessageReceived(data));
    });

    on<HasDroppedWebSocketSendMessage>((event, emit) {
      _channel.sink.add(event.message);
    });

    on<HasDroppedWebSocketMessageReceived>((event, emit) {
      final data = jsonDecode(event.message);
      bool hasDropped = data;

      print(hasDropped);
      emit(HasDroppedWebSocketMessageLoadingReceived(hasDropped));
      emit(HasDroppedWebSocketMessageState(hasDropped));
    });

    on<HasDroppedWebSocketDisconnect>((event, emit) {
      _channel.sink.close();
      emit(HasDroppedWebSocketDisconnected());
    });
  }

  @override
  Future<void> close() {
    _channel.sink.close();
    return super.close();
  }
}
