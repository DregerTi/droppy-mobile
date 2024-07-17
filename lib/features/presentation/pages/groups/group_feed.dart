import 'package:droppy/features/presentation/widgets/atoms/warning_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../bloc/group/feed/goup_feed_bloc.dart';
import '../../bloc/group/feed/group_feed_event.dart';
import '../../bloc/group/feed/group_feed_state.dart';
import '../../widgets/organisms/drop_feed.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GroupFeed extends StatelessWidget {
  final int groupId;

  const GroupFeed({
    super.key,
    required this.groupId
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GroupFeedBloc>(
      create: (context) => sl()..add(GetGroupFeed({
        'id': groupId
      })),
      child: BlocConsumer<GroupFeedBloc, GroupFeedState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is GroupFeedLoading) {
            return SizedBox(
              height: MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight - 10,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: CircularProgressIndicator()),
                ],
              ),
            );
          }

          if(state is GroupFeedDone) {
            return DropFeedWidget(
              drops: state.group?.drops,
              group: state.group,
            );
          }

          if(state is GroupFeedError) {
            return WarningCard(
              message: AppLocalizations.of(context)!.noDrops,
              icon: 'empty'
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}