import 'package:droppy/features/presentation/widgets/organisms/drop_feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../data/models/drop.dart';
import '../../../data/models/user.dart';

class Feed extends StatefulWidget {

  const Feed({
    super.key,
  });

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {

  final _channel = IOWebSocketChannel.connect(
      Uri.parse('ws://localhost:3000/users/my-feed/ws'),headers: {
    'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MjA2NjAzMTEsInJvbGUiOiJ1c2VyIiwic3ViIjo0MzF9.FCYVD00fZb10X-YkJCdEO45RW5DthmcIZNR6FiQ1r7o'
  });

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    List<DropModel> drops = [
      const DropModel(
        id: 1,
        description: 'wsh laissez moi chier trql nn 4 personnes ',
        picturePath: 'https://pbs.twimg.com/media/F7_vMxKWAAAf9CV?format=jpg&name=4096x4096',
        user: UserModel(
          id: 1,
          username: 'John',
          avatar: 'https://i.pinimg.com/originals/48/5f/4f/485f4f34c6074ad220612c1c908d8523.jpg',
        ),
      ),
      const DropModel(
        id: 2,
        description: 'Description 2',
        picturePath: 'https://i.pinimg.com/originals/48/5f/4f/485f4f34c6074ad220612c1c908d8523.jpg',
        user: UserModel(
          id: 2,
          username: 'Jane',
          avatar: 'https://i.pinimg.com/originals/48/5f/4f/485f4f34c6074ad220612c1c908d8523.jpg',
        ),
      ),
      const DropModel(
        id: 3,
        description: 'Description 3',
        picturePath: 'https://i.pinimg.com/originals/48/5f/4f/485f4f34c6074ad220612c1c908d8523.jpg',
        user: UserModel(
          id: 3,
          username: 'Jack',
          avatar: 'https://i.pinimg.com/originals/48/5f/4f/485f4f34c6074ad220612c1c908d8523.jpg',
        )
      ),
    ];

    return StreamBuilder(
      stream: _channel.stream,
      builder: (context, snapshot) {

        print(snapshot.data);

        return DropFeedWidget(
          drops: drops,
        );
      }
    );
  }
}