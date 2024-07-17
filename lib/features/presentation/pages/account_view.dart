import 'package:droppy/features/presentation/bloc/follow/follow_bloc.dart';
import 'package:droppy/features/presentation/widgets/atoms/cached_image_widget.dart';
import 'package:droppy/features/presentation/widgets/atoms/warning_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../injection_container.dart';
import '../../../config/theme/color.dart';
import '../../../config/theme/widgets/text.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/user/user_bloc.dart';
import '../bloc/user/user_event.dart';
import '../bloc/user/user_state.dart';
import '../widgets/atoms/item_header.dart';

class AccountView extends StatefulWidget {
  final String? userId;

  const AccountView({
    super.key,
    this.userId
  });

  @override
  State<AccountView> createState() => _AccountViewState();

}

class _AccountViewState extends State<AccountView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<UsersBloc>(context).add(
      widget.userId != null ? GetUser({
        'id':int.parse(widget.userId ?? '')
      })
      : GetMe({
        'id': BlocProvider.of<AuthBloc>(context).state.auth?.id
      })
    );

    return Scaffold(
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<FollowsBloc>(
              create: (context) => sl(),
            ),
          ],
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<UsersBloc , UsersState>(
                  builder: (context, state) {
                    if (state is UserDone || state is MeDone ) {
                      return
                        ItemHeader(
                          user: state is UserDone ? state.user : state.me,
                          isMe: state is MeDone,
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
                BlocBuilder<UsersBloc , UsersState>(
                  builder: (context, state) {
                    if (state is UserDone || state is MeDone) {
                      final user = state is UserDone ? state.user : state.me;
                      return SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: (user?.id == BlocProvider.of<AuthBloc>(context).state.auth?.id ||
                            user?.isPrivate == false ||
                            (user?.currentFollow != null && user?.currentFollow?.status == 1)) ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if(user?.lastDrop != null) Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24, top: 42),
                              child: GestureDetector(
                                onTap: () {
                                  context.pushNamed(
                                    'drop-from-profile',
                                    pathParameters: {
                                      'userId': user?.id.toString() ?? '',
                                      'username': user?.username ?? '',
                                      'dropId': user?.lastDrop?.id.toString() ?? ''
                                    }
                                  );
                                },
                                child: Stack(
                                  children: [
                                    CachedImageWidget(
                                      borderRadius: BorderRadius.circular(16),
                                      imageUrl: user?.lastDrop?.picturePath ?? '',
                                      height: 160,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                    Container(
                                      height: 160,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            backgroundColor.withOpacity(1),
                                            backgroundColor.withOpacity(0.1),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 160,
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'DROP DU JOUR',
                                            style: textTheme.titleMedium,
                                          ),
                                          const SizedBox(height: 8),
                                          Expanded(
                                            child: Text(
                                              user?.lastDrop?.description ?? '',
                                              maxLines : 2,
                                              overflow : TextOverflow.ellipsis,
                                              style: textTheme.bodySmall,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              CachedImageWidget(
                                                width: 56,
                                                height: 56,
                                                borderRadius: BorderRadius.circular(16),
                                                imageUrl: user?.lastDrop?.contentPicturePath ?? '',
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      user?.lastDrop?.type ?? '',
                                                      style: textTheme.titleMedium,
                                                    ),
                                                    Text(
                                                      user?.lastDrop?.contentTitle ?? '',
                                                      style: textTheme.bodySmall,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ),
                            if (user?.pinnedDrops?.length != 0) Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24, top: 36, bottom: 8),
                              child: Text(
                                'Pins',
                                style: textTheme.titleMedium
                              )
                            ),
                            if (user?.pinnedDrops?.length != 0) SizedBox(
                              height: 180,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                separatorBuilder: (BuildContext context, int index) {
                                  return const SizedBox(width: 16);
                                },
                                itemCount: user?.pinnedDrops!.length ?? 0 + 2,
                                itemBuilder: (BuildContext context, int index) {
                                  if(index == 0 || index == (user?.pinnedDrops!.length ?? 0) + 1){
                                    return const SizedBox(width: 8);
                                  }
                                  return GestureDetector(
                                    onTap: () {
                                      context.pushNamed(
                                        'drop-from-profile',
                                        pathParameters: {
                                          'userId': user?.id.toString() ?? '',
                                          'username': user?.username ?? '',
                                          'dropId': user?.pinnedDrops?[index - 1].id.toString() ?? ''
                                        }
                                      );
                                    },
                                    child: SizedBox(
                                      width: (MediaQuery.of(context).size.width - 10) / 3,
                                      child: Stack(
                                        children: [
                                          CachedImageWidget(
                                            borderRadius: BorderRadius.circular(16),
                                            imageUrl: user?.pinnedDrops?[index - 1].picturePath ?? '',
                                            height: 180,
                                            width: MediaQuery.of(context).size.width,
                                          ),
                                          Container(
                                            height: 180,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(16),
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  backgroundColor.withOpacity(0.9),
                                                  backgroundColor.withOpacity(0),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 190,
                                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  user?.pinnedDrops?[index - 1].contentTitle ?? '',
                                                  style: textTheme.titleSmall,
                                                ),
                                                const SizedBox(height: 8),
                                                CachedImageWidget(
                                                  width: 56,
                                                  height: 56,
                                                  borderRadius: BorderRadius.circular(16),
                                                  imageUrl: user?.pinnedDrops?[index - 1].contentPicturePath ?? '',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              ),
                            )
                          ],
                        ) : const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 80),
                          child: Center(
                            child: WarningCard(
                              message: 'Ce compte est privé',
                              icon: 'lock',
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
),
      ),
    );
  }
}