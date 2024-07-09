import 'package:droppy/features/presentation/widgets/organisms/drop_feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../data/models/drop.dart';
import '../../../data/models/user.dart';

class Feed extends HookWidget {

  const Feed({
    super.key,
  });

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

    return DropFeedWidget(
      drops: drops,
    );
  }

}