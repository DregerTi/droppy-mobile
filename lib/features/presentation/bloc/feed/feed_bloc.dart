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

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  late final WebSocketChannel _channel;

  List<DropEntity> _lastDrops = [];

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

      if(data is List) {
        _lastDrops = data.map<DropModel>((dynamic i) => DropModel.fromJson(i as Map<String, dynamic>)).toList();
      } else if (data is Map<String, dynamic>) {
        DropModel drop = DropModel.fromJson(data);

        //check if the drop already exists in the list
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
