import 'package:droppy/features/presentation/bloc/group/goup_bloc.dart';
import 'package:droppy/features/presentation/widgets/atoms/cached_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/theme/color.dart';
import '../../../../config/theme/widgets/text.dart';
import '../../../../injection_container.dart';
import '../../bloc/group/group_event.dart';
import '../../bloc/group/group_state.dart';
import '../../widgets/atoms/group_header.dart';
import '../../widgets/atoms/item_header.dart';

class GroupView extends StatefulWidget {
  final String? groupId;

  const GroupView({
    super.key,
    this.groupId
  });

  @override
  State<GroupView> createState() => _GroupViewState();

}

class _GroupViewState extends State<GroupView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider<GroupsBloc>(
            create: (context) => sl()..add(
              GetGroup({
                'id':int.parse(widget.groupId ?? '')
              })
            ),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<GroupsBloc , GroupsState>(
                    builder: (context, state) {
                      if (state is GroupDone ) {
                        return GroupHeader(
                          group: state.group,
                        );
                      }
                      return SizedBox(
                        height: MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight - 30,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(child: CircularProgressIndicator()),
                          ],
                        ),
                      );
                    },
                  ),
                  BlocBuilder<GroupsBloc , GroupsState>(
                    builder: (context, state) {
                      if (state is GroupDone) {
                        if (state.group?.description != null || state.group?.description != ''){
                          return SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 24, right: 24, top: 36, bottom: 8),
                                  child: Text(
                                      state.group?.description ?? '',
                                      style: textTheme.bodyMedium
                                  )
                                ),
                              ],
                            ),
                          );
                        }
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }

}