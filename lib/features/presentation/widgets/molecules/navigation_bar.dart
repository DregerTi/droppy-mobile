import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/color.dart';

class NavigationBarWidget extends StatefulWidget {

  const NavigationBarWidget({super.key});

  @override
  State<NavigationBarWidget> createState() => _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentPageIndex,
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
        });

        switch (index) {
          case 0:
            context.go('/');
            break;
          case 1:
            context.goNamed('map');
            break;
          case 2:
            context.goNamed('groups');
            break;
          case 3:
            context.goNamed('account');
            break;
          default:
            context.go('/');
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_rounded, size: 28,),
          label: '',
          selectedIcon: Icon(Icons.home_rounded, color: primaryColor, size: 30,),
        ),
        NavigationDestination(
          icon: Icon(Icons.explore_rounded, size: 28,),
          label: '',
          selectedIcon: Icon(Icons.explore_rounded, color: primaryColor, size: 30,),
        ),
        NavigationDestination(
          icon: Icon(Icons.group_rounded, size: 28,),
          label: '',
          selectedIcon: Icon(Icons.group_rounded, color: primaryColor, size: 30,),
        ),
        NavigationDestination(
          icon: Icon(Icons.person_rounded, size: 28,),
          label: '',
          selectedIcon: Icon(Icons.person_rounded, color: primaryColor, size: 30,),
        ),
      ],
    );
  }
}