import 'package:droppy/features/presentation/widgets/atoms/cached_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    Key? key,
    this.userId
  }) : super(key: key);

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
    return Scaffold(
      body: SafeArea(
        child: BlocProvider<UsersBloc>(
            create: (context) => sl()..add(
                widget.userId != null ? GetUser({
                  'id':int.parse(widget.userId ?? '')
                })
                : GetMe({
                  'id': BlocProvider.of<AuthBloc>(context).state.auth?.id
                }
              )
            ),
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
                        return _buildBody(context, state is UserDone ? state.user : state.me);
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

   Widget _buildBody(context, user) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(user.lastDrop != null) Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 42),
            child: Stack(
              children: [
                CachedImageWidget(
                  borderRadius: BorderRadius.circular(16),
                  imageUrl: user.lastDrop?.picturePath ?? '',
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
                          user.lastDrop?.description ?? '',
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
                            imageUrl: "https://pbs.twimg.com/media/F7_vMxKWAAAf9CV?format=jpg&name=4096x4096",
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Musique',
                                style: textTheme.titleMedium,
                              ),
                              Text(
                                'Goody ahh sound effect - 2h',
                                style: textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          ),
          if (user.pinnedDrops != null) Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 36, bottom: 8),
            child: Text(
                'Pins',
                style: textTheme.titleMedium
            )
          ),
          if (user.pinnedDrops != null) SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(width: 16);
              },
              itemCount: user.pinnedDrops!.length + 2,
              itemBuilder: (BuildContext context, int index) {
                if(index == 0 || index == user.pinnedDrops!.length + 1){
                  return const SizedBox(width: 8);
                }
                return SizedBox(
                  width: (MediaQuery.of(context).size.width - 10) / 3,
                  child: Stack(
                    children: [
                      CachedImageWidget(
                        borderRadius: BorderRadius.circular(16),
                        imageUrl: user.pinnedDrops?[index - 1].picturePath ?? '',
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
                              'Goody ahh sound effect - 2h',
                              style: textTheme.titleSmall,
                            ),
                            const SizedBox(height: 8),
                            CachedImageWidget(
                              width: 56,
                              height: 56,
                              borderRadius: BorderRadius.circular(16),
                              imageUrl: "https://pbs.twimg.com/media/F7_vMxKWAAAf9CV?format=jpg&name=4096x4096",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            ),
          )
        ],
      ),
    );
  }

}