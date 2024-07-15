import 'dart:async';
import 'package:droppy/features/presentation/bloc/user/user_event.dart';
import 'package:droppy/features/presentation/bloc/user/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/color.dart';
import '../../../../injection_container.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/group/goup_bloc.dart';
import '../../bloc/user/user_bloc.dart';
import '../../widgets/molecules/app_bar_widget.dart';
import '../../widgets/organisms/search_groups.dart';

class GroupsView extends StatefulWidget {

  const GroupsView({
    super.key,
  });

  @override
  State<GroupsView> createState() => _GroupsViewState();
}

class _GroupsViewState extends State<GroupsView> {
  TextEditingController searchFieldController = TextEditingController();
  Timer? debounce;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    debounce?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GroupsBloc>(
          create: (context) => sl(),
        ),
        BlocProvider<UsersBloc>(
          create: (context) => sl()..add(GetMe({
            'id': BlocProvider.of<AuthBloc>(context).state.auth!.id,
          }))
        ),
      ],
      child: Scaffold(
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
                  leadingOnPressed: () {
                    context.pushNamed('add-group');
                  },
                  mainActionIcon: const Icon(Icons.notifications_rounded),
                  isMainActionActive: true,
                  mainActionOnPressed: () {
                    context.pushNamed('notification');
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: BlocConsumer<UsersBloc, UsersState>(
                  listener: (BuildContext context, UsersState state) {},
                  builder: (_, state) {
                    if(state is MeDone){
                      return SearchGroups(
                        onTap: (group) {
                          context.pushNamed(
                            'group-feed',
                            pathParameters: {
                              'groupId': group.id.toString(),
                            },
                          );
                        },
                      );
                    }
                    return const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}