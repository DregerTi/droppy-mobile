import 'dart:convert';
import 'package:droppy/features/domain/entities/drop.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../../core/constants/constants.dart';
import '../../../data/models/drop.dart';
import 'feed_event.dart';
import 'feed_state.dart';
import 'dart:async';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  late WebSocketChannel _channel;
  final int _reconnectDelay = 5;
  List<DropEntity> _lastDrops = [];
  bool retry = true;

  FeedBloc() : super(WebSocketInitial()) {
    on<WebSocketConnect>(onWebSocketConnect);
    on<WebSocketReconnect>(onWebSocketReconnect);
    on<WebSocketSendMessage>(onWebSocketSendMessage);
    on<WebSocketMessageReceived>(onWebSocketMessageReceived);
    on<WebSocketDisconnect>(onWebSocketDisconnect);
  }

  void onWebSocketConnect(WebSocketConnect event, Emitter<FeedState> emit) async {
    await _connectWebSocket(emit);
  }

  Future<void> _connectWebSocket(Emitter<FeedState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');

    _channel = IOWebSocketChannel.connect(
      Uri.parse('$wsBaseUrl/users/my-feed/ws'),
      headers: {'Authorization': 'Bearer $jwtToken'},
    );

    _channel.stream.listen(
          (data) {
        add(WebSocketMessageReceived(data));
      },
      onDone: () {
        add(WebSocketReconnect());
      },
      onError: (error) {
        add(WebSocketReconnect());
      },
    );
  }

  void onWebSocketReconnect(WebSocketReconnect event, Emitter<FeedState> emit) {
    if(retry == true) {
      emit(WebSocketReconnecting());
      Timer(Duration(seconds: _reconnectDelay), () {
        add(WebSocketConnect());
      });
    }
    retry = true;
  }

  void onWebSocketSendMessage(WebSocketSendMessage event, Emitter<FeedState> emit) {
    _channel.sink.add(event.message);
  }

  void onWebSocketMessageReceived(WebSocketMessageReceived event, Emitter<FeedState> emit) {
    final data = jsonDecode(event.message);
    if(data is List) {
      _lastDrops = data.map<DropModel>((dynamic i) => DropModel.fromJson(i as Map<String, dynamic>)).toList();
    } else if (data is Map<String, dynamic>) {
      DropModel drop = DropModel.fromJson(data);

      if(_lastDrops!.any((element) => element!.id == drop.id)) {
        if(_lastDrops.isNotEmpty) {
          final index = _lastDrops!.indexWhere((element) => element!.id == drop.id);
          if(index != -1) {
            _lastDrops![index] = drop;
          }
        }
      } else {
        _lastDrops!.insert(0, drop);
      }
    }
    emit(WebSocketMessageLoadingReceived(_lastDrops));
    emit(WebSocketMessageState(_lastDrops));
  }

  void onWebSocketDisconnect(WebSocketDisconnect event, Emitter<FeedState> emit) {
    retry = false;
    _channel.sink.close();
    emit(WebSocketDisconnected());
  }

  @override
  Future<void> close() {
    _channel.sink.close();
    return super.close();
  }
}

