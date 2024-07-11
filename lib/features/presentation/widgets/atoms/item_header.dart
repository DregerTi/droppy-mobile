import 'package:droppy/config/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/widgets/button.dart';
import '../../../../config/theme/widgets/text.dart';
import '../../../domain/entities/user.dart';
import '../../bloc/user/user_bloc.dart';
import '../../bloc/user/user_state.dart';
import '../molecules/app_bar_widget.dart';
import 'cached_image_widget.dart';

class ItemHeader extends StatelessWidget {
  final UserEntity? user;
  final bool isMe;

  const ItemHeader({
    super.key,
    required this.user,
    this.isMe = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 6, bottom: 12, left: 20, right: 20),
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(46)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () => context.goNamed('notifications'),
                  style: iconButtonThemeData.style?.copyWith(
                    backgroundColor: MaterialStateProperty.all<Color>(onPrimaryColor),
                    foregroundColor: MaterialStateProperty.all<Color>(onBackgroundColor),
                    overlayColor: MaterialStateProperty.all<Color>(Colors.black.withOpacity(0.09)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                if(isMe) IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => context.goNamed(
                    'preferences',
                    extra: {
                      'user': user,
                    },
                  ),
                  style: iconButtonThemeData.style?.copyWith(
                    backgroundColor: MaterialStateProperty.all<Color>(onPrimaryColor),
                    foregroundColor: MaterialStateProperty.all<Color>(onBackgroundColor),
                    overlayColor: MaterialStateProperty.all<Color>(Colors.black.withOpacity(0.09)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ),
          BlocBuilder<UsersBloc, UsersState>(
            builder: (context, state) {
              return AppBarWidget(
                mainActionIcon: user?.id == null ? const Icon(Icons.settings) : null,
                mainActionOnPressed: () {
                  if(state is MeDone) {
                    context.goNamed(
                      'preferences',
                      extra: {
                        'user': state.me,
                      },
                    );
                  }
                },
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (user?.avatar != null) CachedImageWidget(
                imageUrl: user?.avatar ?? '',
                borderRadius: BorderRadius.circular(24),
                width: (MediaQuery.of(context).size.width - 40) / 3.6,
                height: (MediaQuery.of(context).size.width - 40) / 3.6,
              ) else ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: SvgPicture.asset(
                  'lib/assets/images/avatar.svg',
                  width: (MediaQuery.of(context).size.width - 40) / 3.6,
                  height: (MediaQuery.of(context).size.width - 40) / 3.6,
                ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.username ?? '',
                    style: textTheme.headlineSmall?.copyWith(color: backgroundColor),
                  ),
                  Text(
                    user?.bio ?? '',
                    style: textTheme.labelSmall?.copyWith(color: onBackgroundColor),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () => {

                      },
                      style: elevatedButtonThemeData.style?.copyWith(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(horizontal: 10, vertical: 0)),
                      ),
                      child: Text(
                        'Follow',
                        style: textTheme.labelSmall?.copyWith(color: onBackgroundColor),
                      ),
                  ),
                ],
              )
            ]
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 60) / 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '12',
                        style: textTheme.headlineMedium?.copyWith(color: onBackgroundColor),
                      ),
                      Text(
                        'Likes',
                        style: textTheme.labelSmall?.copyWith(color: onBackgroundColor),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 60) / 3,
                  child: GestureDetector(
                    onTap: () => context.goNamed(
                      'followers',
                      pathParameters: {
                        'userId': user?.id.toString() ?? '',
                        'username': user?.username ?? 'Incroyable mec',
                      },
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          user?.totalFollowers.toString() ?? '0',
                          style: textTheme.headlineMedium?.copyWith(color: onBackgroundColor),
                        ),
                        Text(
                          'Followers',
                          style: textTheme.labelSmall?.copyWith(color: onBackgroundColor),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 60) / 3,
                  child: GestureDetector(
                    onTap: () => context.goNamed(
                      'followed',
                      pathParameters: {
                        'userId': user?.id.toString() ?? '',
                        'username': user?.username ?? 'Incroyable mec',
                      },
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          user?.totalFollowed.toString() ?? '0',
                          style: textTheme.headlineMedium?.copyWith(color: onBackgroundColor),
                        ),
                        Text(
                          'Following',
                          style: textTheme.labelSmall?.copyWith(color: onBackgroundColor),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}