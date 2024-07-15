import 'package:droppy/features/presentation/bloc/follow/pending/pending_follow_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../../config/theme/color.dart';
import '../../../../config/theme/widgets/text.dart';
import '../../bloc/follow/pending/pending_follow_state.dart';
import '../../bloc/follow/pending/pending_follow_bloc.dart';
import '../../widgets/atoms/cached_image_widget.dart';
import '../../widgets/atoms/warning_card.dart';
import '../../widgets/molecules/app_bar_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserFollowersPendingView extends StatelessWidget {
  const UserFollowersPendingView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Column(
              children: [
                AppBarWidget(
                  leadingIcon: const Icon(Icons.arrow_back),
                  leadingOnPressed: () {
                    context.pop();
                  },
                  title: 'Notifications',
                ),
                Expanded(
                  child: BlocConsumer<PendingFollowBloc, PendingFollowState>(
                    listener: (BuildContext context, PendingFollowState state) {},
                    builder: (_,state) {
                      if (state is PendingFollowWebSocketInitial) {
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
                      if(state is PendingFollowWebSocketDisconnected) {
                        return Center(
                          child: WarningCard(
                              message: AppLocalizations.of(context)!.loadingError,
                              icon: 'empty'
                          ),
                        );
                      }
                      if(state is PendingFollowWebSocketMessageState || state is PendingFollowWebSocketMessageReceived) {
                        if (state.follows?.isEmpty ?? true) {
                          return const WarningCard(
                            icon: 'empty',
                            message: 'Aucun résultat',
                          );
                        } else {
                          return SingleChildScrollView(
                              physics: const ClampingScrollPhysics(),
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.follows?.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: ListTile(
                                      onTap: () {
                                        context.pushNamed(
                                          'user-profile',
                                          pathParameters: {
                                            'userId': state.follows?[index].follower?.id.toString() ?? '',
                                          },
                                        );
                                      },
                                      leading: state.follows?[index].follower?.avatar != null ? CachedImageWidget(
                                        borderRadius: BorderRadius.circular(16),
                                        imageUrl: state.follows?[index].follower?.avatar ?? '',
                                        height: 50,
                                        width: 50,
                                      ) : ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: SvgPicture.asset(
                                          'lib/assets/images/avatar.svg',
                                          height: 50,
                                          width: 50,
                                        ),
                                      ),
                                      title: Text(
                                          '${state.follows?[index].follower?.username} vous a envoyé une demande de suivi',
                                          style: Theme.of(context).textTheme.titleSmall
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Row(
                                          children:[
                                            Expanded(
                                              child: GestureDetector(
                                                  onTap: () {

                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                    decoration: BoxDecoration(
                                                      color: surfaceColor,
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                          'Refuser',
                                                          style: textTheme.labelSmall
                                                      ),
                                                    ),
                                                  )
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {

                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                  decoration: BoxDecoration(
                                                    color: onPrimaryColor,
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'Accepter',
                                                      style: textTheme.labelSmall?.copyWith(
                                                        color: surfaceColor
                                                      )
                                                    ),
                                                  ),
                                                )
                                              ),
                                            )
                                          ]
                                        ),
                                      )
                                    ),
                                  );
                                },
                              )
                          );
                        }
                      }
                      return const SizedBox();
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

