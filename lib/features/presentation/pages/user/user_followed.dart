import 'package:droppy/features/presentation/bloc/follow/get/follow_get_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../../config/theme/color.dart';
import '../../../../config/theme/widgets/text.dart';
import '../../../../injection_container.dart';
import '../../bloc/follow/get/follow_get_bloc.dart';
import '../../bloc/follow/get/follow_get_state.dart';
import '../../widgets/atoms/cached_image_widget.dart';
import '../../widgets/atoms/warning_card.dart';
import '../../widgets/molecules/app_bar_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserFollowedView extends StatelessWidget {
  final String? userId;
  final String? username;

  const UserFollowedView({
    super.key,
    this.userId,
    this.username,
  });

  @override
  Widget build(BuildContext context) {

    return BlocProvider<FollowGetBloc>(
      create: (context) => sl()..add(GetUserFollowed({
        'id': int.parse(userId ?? '')
      })),
      child: Scaffold(
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
                    title: username ?? '',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, right: 26, left: 26),
                    child: Row(
                      children: [
                        Text(
                          'Following',
                          style: textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: BlocConsumer<FollowGetBloc, FollowGetState>(
                      listener: (BuildContext context, FollowGetState state) {  },
                      builder: (_,state) {
                        if(state is FollowedLoading) {
                          return const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if(state is FollowedError) {
                          return WarningCard(
                            icon: 'error',
                            message: AppLocalizations.of(context)!.anErrorOccurred,
                          );
                        }
                        if(state is FollowedDone) {
                          if (state.users?.isEmpty ?? true) {
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
                                  itemCount: state.users?.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      onTap: () {
                                        context.pushNamed(
                                          'user-profile',
                                          pathParameters: {
                                            'userId': state.users?[index]?.id.toString() ?? '',
                                          },
                                        );
                                      },
                                      leading: state.users?[index]?.avatar != null ? CachedImageWidget(
                                        borderRadius: BorderRadius.circular(16),
                                        imageUrl: state.users?[index]?.avatar ?? '',
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
                                          state.users?[index]?.username ?? '',
                                          style: Theme.of(context).textTheme.titleMedium
                                      ),
                                      subtitle: Text(
                                        state.users?[index]?.bio ?? '',
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