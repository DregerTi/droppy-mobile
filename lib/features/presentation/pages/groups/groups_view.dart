import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/color.dart';
import '../../widgets/molecules/app_bar_widget.dart';

class GroupsView extends StatelessWidget {

  const GroupsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 30,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: backgroundColor.withOpacity(0.8),
                      offset: const Offset(0, -15),
                      spreadRadius: 30,
                      blurRadius: 30,
                    ),
                  ],
                ),
              ),
              AppBarWidget(
                leadingIcon: const Icon(Icons.group_add),
                mainActionIcon: const Icon(Icons.notifications),
                mainActionOnPressed: () {
                  context.goNamed('notifications');
                },
              ),
              Positioned(
                child: Padding(
                  padding: const EdgeInsets.only(top: 70),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Groups',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(top: 12, left: 30, right: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                  ],
                ),
              )
          ),
        ],
      ),
    );
  }
}