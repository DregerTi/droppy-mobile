import 'package:droppy/config/theme/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/drop.dart';
import '../../../data/models/user.dart';
import '../../widgets/organisms/drop_tile.dart';

class Feed extends HookWidget {

  const Feed({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<DropModel> drops = [
      const DropModel(
        id: 1,
        description: 'Description 1',
        picturePath: 'https://i.pinimg.com/originals/48/5f/4f/485f4f34c6074ad220612c1c908d8523.jpg',
        user: UserModel(
          id: 1,
          firstname: 'John',
          avatar: 'https://i.pinimg.com/originals/48/5f/4f/485f4f34c6074ad220612c1c908d8523.jpg',
        ),
      ),
      const DropModel(
        id: 2,
        description: 'Description 2',
        picturePath: 'https://i.pinimg.com/originals/48/5f/4f/485f4f34c6074ad220612c1c908d8523.jpg',
        user: UserModel(
          id: 2,
          firstname: 'Jane',
          avatar: 'https://i.pinimg.com/originals/48/5f/4f/485f4f34c6074ad220612c1c908d8523.jpg',
        ),
      ),
      const DropModel(
        id: 3,
        description: 'Description 3',
        picturePath: 'https://i.pinimg.com/originals/48/5f/4f/485f4f34c6074ad220612c1c908d8523.jpg',
        user: UserModel(
          id: 3,
          firstname: 'Jack',
          avatar: 'https://i.pinimg.com/originals/48/5f/4f/485f4f34c6074ad220612c1c908d8523.jpg',
        )
      ),
    ];

    final FixedExtentScrollController fixedExtentScrollController = FixedExtentScrollController();

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight - 50,
          decoration: const BoxDecoration(
            color: errorColor,
            borderRadius: BorderRadius.all(
              Radius.circular(28)
            ),
          ),
          child: Expanded(
            child: ListWheelScrollView(
              controller: fixedExtentScrollController,
              physics: const FixedExtentScrollPhysics(),
              overAndUnderCenterOpacity: 0,
              itemExtent: MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight - 50,
              children: drops.map((drop) {
                return DropTileWidget(
                  drop: drop,
                  onDropPressed: (drop) {
                    context.goNamed('drop', pathParameters: {'dropId': drop.id.toString()});
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

}