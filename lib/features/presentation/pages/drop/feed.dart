import 'package:droppy/features/presentation/widgets/atoms/warning_card.dart';
import 'package:droppy/features/presentation/widgets/organisms/drop_feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/io.dart';
import '../../bloc/feed/feed_bloc.dart';
import '../../bloc/feed/feed_state.dart';

final channel = IOWebSocketChannel.connect(
    Uri.parse('ws://localhost:3000/users/my-feed/ws'),headers: {
  'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MjA3MjAyMzUsInJvbGUiOiJ1c2VyIiwic3ViIjo0MzF9.gAvAnW3FlSDwOu-YKAgsdJTBazBWwdheSUBmK_xWW7k'
});

class Feed extends StatelessWidget {

  const Feed({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FeedBloc>(
      create: (context) => FeedBloc(channel),
      child: BlocConsumer<FeedBloc, FeedState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is WebSocketInitial) {
            return SizedBox(
              height: MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight - 30,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: CircularProgressIndicator()),
                ],
              ),
            );
          }

          if(state is WebSocketMessageState) {
            return DropFeedWidget(drops: state.drops);
          }

          if(state is WebSocketDisconnected) {
            return const WarningCard(
              message: 'Aucun drop',
              icon: 'empty'
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}