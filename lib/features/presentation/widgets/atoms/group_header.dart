import 'package:droppy/config/theme/color.dart';
import 'package:droppy/features/domain/entities/group.dart';
import 'package:droppy/features/presentation/bloc/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/widgets/button.dart';
import '../../../../config/theme/widgets/text.dart';
import '../../bloc/user/user_bloc.dart';
import '../../bloc/user/user_state.dart';
import '../molecules/app_bar_widget.dart';
import 'cached_image_widget.dart';

class GroupHeader extends StatelessWidget {
  final GroupEntity? group;
  final bool isMe;

  const GroupHeader({
    super.key,
    required this.group,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () => context.pop(),
                  style: iconButtonThemeData.style?.copyWith(
                    backgroundColor: WidgetStateProperty.all<Color>(onPrimaryColor),
                    foregroundColor: WidgetStateProperty.all<Color>(onBackgroundColor),
                    overlayColor: WidgetStateProperty.all<Color>(Colors.black.withOpacity(0.09)),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications),
                      onPressed: () => context.goNamed('notifications'),
                      style: iconButtonThemeData.style?.copyWith(
                        backgroundColor: WidgetStateProperty.all<Color>(onPrimaryColor),
                        foregroundColor: WidgetStateProperty.all<Color>(onBackgroundColor),
                        overlayColor: WidgetStateProperty.all<Color>(Colors.black.withOpacity(0.09)),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    if(group?.createdBy?.id == BlocProvider.of<AuthBloc>(context).state.auth?.id) IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () => context.goNamed(
                        'group-setting',
                        extra: {
                          'groupId': group?.id,
                        },
                      ),
                      style: iconButtonThemeData.style?.copyWith(
                        backgroundColor: WidgetStateProperty.all<Color>(onPrimaryColor),
                        foregroundColor: WidgetStateProperty.all<Color>(onBackgroundColor),
                        overlayColor: WidgetStateProperty.all<Color>(Colors.black.withOpacity(0.09)),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (group?.picturePath != null) CachedImageWidget(
                imageUrl: group?.picturePath ?? '',
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    group?.name ?? '',
                    style: textTheme.headlineSmall?.copyWith(color: backgroundColor),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () => {
                        context.goNamed(
                          'group-feed',
                          pathParameters: {
                            'groupId': group?.id.toString() ?? '',
                          },
                        ),
                      },
                      style: elevatedButtonThemeData.style?.copyWith(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(horizontal: 10, vertical: 0)),
                      ),
                      child: Text(
                        'Feed',
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
                  width: (MediaQuery.of(context).size.width - 60) / 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '12',
                        style: textTheme.headlineMedium?.copyWith(color: onBackgroundColor),
                      ),
                      Text(
                        'Drops',
                        style: textTheme.labelSmall?.copyWith(color: onBackgroundColor),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 60) / 2,
                  child: GestureDetector(
                    onTap: () => {},
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '0',
                          style: textTheme.headlineMedium?.copyWith(color: onBackgroundColor),
                        ),
                        Text(
                          'Membre',
                          style: textTheme.labelSmall?.copyWith(color: onBackgroundColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}