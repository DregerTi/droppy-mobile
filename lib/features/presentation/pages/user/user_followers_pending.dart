import 'package:droppy/features/presentation/bloc/follow/follow_event.dart';
import 'package:droppy/features/presentation/bloc/follow/pending/pending_follow_event.dart';
import 'package:droppy/features/presentation/widgets/atoms/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../../config/theme/color.dart';
import '../../../../config/theme/widgets/text.dart';
import '../../../../injection_container.dart';
import '../../bloc/follow/follow_bloc.dart';
import '../../bloc/follow/follow_state.dart';
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
    return BlocProvider<FollowsBloc>(
      create: (context) => sl(),
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              BlocListener<FollowsBloc, FollowsState>(
                listener: (BuildContext context, FollowsState state) {

                  if (state is AcceptFollowDone) {
                    snackBarWidget(
                      message: AppLocalizations.of(context)!.followRequestAccepted,
                      context: context
                    );
                  }
                  if (state is AcceptFollowError) {
                    snackBarWidget(
                      message: AppLocalizations.of(context)!.errorAcceptingFollowRequest,
                      type: 'error',
                      context: context
                    );
                  }
                  if (state is RefuseFollowDone) {
                    snackBarWidget(
                      message: AppLocalizations.of(context)!.followRequestDeclined,
                      context: context
                    );
                  }
                  if (state is RefuseFollowError) {
                    snackBarWidget(
                      message: AppLocalizations.of(context)!.errorDecliningFollowRequest,
                      type: 'error',
                      context: context
                    );
                  }
                },
                child: const SizedBox(),
              ),
              Column(
                children: [
                  AppBarWidget(
                    leadingIcon: const Icon(Icons.arrow_back),
                    leadingOnPressed: () {
                      context.pop();
                    },
                    title: AppLocalizations.of(context)!.notifications,
                  ),
                  Expanded(
                    child: BlocConsumer<PendingFollowBloc, PendingFollowState>(
                      listener: (BuildContext context, PendingFollowState state) {},
                      builder: (_,state) {
                        if (state is PendingFollowWebSocketInitial) {
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
                            return WarningCard(
                              icon: 'empty',
                              message: AppLocalizations.of(context)!.noResults,
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
                                        '${state.follows?[index].follower?.username} ${AppLocalizations.of(context)!.followRequestSentYou}',
                                        style: Theme.of(context).textTheme.titleSmall
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Row(
                                          children:[
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  context.read<FollowsBloc>().add(RefuseFollow({
                                                    'id': state.follows?[index].id,
                                                  }));
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                  decoration: BoxDecoration(
                                                    color: surfaceColor,
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      AppLocalizations.of(context)!.decline,
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
                                                  context.read<FollowsBloc>().add(AcceptFollow({
                                                    'id': state.follows?[index].id,
                                                  }));
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                  decoration: BoxDecoration(
                                                    color: onPrimaryColor,
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      AppLocalizations.of(context)!.accept,
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
      ),
    );
  }
}

