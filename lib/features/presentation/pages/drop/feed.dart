import 'package:droppy/features/presentation/widgets/atoms/warning_card.dart';
import 'package:droppy/features/presentation/widgets/organisms/drop_feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/color.dart';
import '../../../../config/theme/widgets/text.dart';
import '../../bloc/feed/feed_bloc.dart';
import '../../bloc/feed/feed_event.dart';
import '../../bloc/feed/feed_state.dart';
import '../../bloc/follow/pending/pending_follow_bloc.dart';
import '../../bloc/follow/pending/pending_follow_event.dart';
import '../../bloc/follow/pending/pending_follow_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../bloc/has_dropped/has_dropped_bloc.dart';
import '../../bloc/has_dropped/has_dropped_event.dart';
import '../../bloc/has_dropped/has_dropped_state.dart';

class Feed extends StatelessWidget {

  const Feed({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if(BlocProvider.of<FeedBloc>(context).state is WebSocketInitial){
      BlocProvider.of<FeedBloc>(context).add(WebSocketConnect());
    }

    if(BlocProvider.of<HasDroppedBloc>(context).state is HasDroppedWebSocketInitial){
      BlocProvider.of<HasDroppedBloc>(context).add(HasDroppedWebSocketConnect());
    }

    if(BlocProvider.of<PendingFollowBloc>(context).state is PendingFollowWebSocketInitial){
      BlocProvider.of<PendingFollowBloc>(context).add(PendingFollowWebSocketConnect());
    }

    return BlocConsumer<FeedBloc, FeedState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is WebSocketInitial) {
          return SizedBox(
            height: MediaQuery.of(context).size.height - 50,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: CircularProgressIndicator()),
              ],
            ),
          );
        }

        if(state is WebSocketMessageState || state is WebSocketMessageReceived) {
          return DropFeedWidget(drops: state.drops);
        }

        if(state is WebSocketDisconnected) {
          return Center(
            child: Column(
              children: [
                WarningCard(
                  message: AppLocalizations.of(context)!.noDrops,
                  icon: 'empty'
                ),
                ElevatedButton(
                  onPressed: () {
                    context.pushNamed('add-drop');
                  },
                  child: Text(
                    AppLocalizations.of(context)!.postADrop,
                    style: textTheme.labelMedium?.copyWith(
                      color: backgroundColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}