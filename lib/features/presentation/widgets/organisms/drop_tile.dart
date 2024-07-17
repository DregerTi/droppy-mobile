import 'dart:ui';
import 'package:droppy/config/theme/color.dart';
import 'package:droppy/features/domain/entities/drop.dart';
import 'package:droppy/features/presentation/bloc/auth/auth_bloc.dart';
import 'package:droppy/features/presentation/widgets/atoms/snack_bar.dart';
import 'package:droppy/features/presentation/widgets/molecules/comment_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../config/theme/widgets/text.dart';
import '../../bloc/has_dropped/has_dropped_bloc.dart';
import '../../bloc/has_dropped/has_dropped_event.dart';
import '../../bloc/has_dropped/has_dropped_state.dart';
import '../atoms/cached_image_widget.dart';
import '../atoms/like_btn.dart';
import '../atoms/pin_btn.dart';

class DropTileWidget extends StatelessWidget {
  final DropEntity ? drop;
  final void Function(DropEntity drop) ? onDropPressed;

  const DropTileWidget({
    Key ? key,
    this.drop,
    this.onDropPressed,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    if(BlocProvider.of<HasDroppedBloc>(context).state is HasDroppedWebSocketInitial){
      BlocProvider.of<HasDroppedBloc>(context).add(HasDroppedWebSocketConnect());
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight - 50,
      child: Stack(
        children: [
          CachedImageWidget(
            borderRadius: BorderRadius.circular(46),
            imageUrl: drop!.picturePath ?? "https://i.pinimg.com/originals/48/5f/4f/485f4f34c6074ad220612c1c908d8523.jpg",
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight - 50,
          ),
          Positioned(
            bottom: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(46),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Container(
                    color: onPrimaryColor.withOpacity(0.4),
                    padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 26),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if(drop!.location != null && drop!.location != "") Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: onPrimaryColor,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                              Icons.location_on,
                                              color: backgroundColor,
                                              size: 16
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            drop!.location ?? '',
                                            style: textTheme.labelSmall?.copyWith(color: backgroundColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if(drop?.totalLikes != null && drop?.totalLikes != 0 && drop!.location != null && drop!.location != "") const SizedBox(width: 8),
                                    if(drop?.totalLikes != null && drop?.totalLikes != 0) Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: onPrimaryColor,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                              Icons.favorite_rounded,
                                              color: backgroundColor,
                                              size: 16
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${drop?.totalLikes}',
                                            style: textTheme.labelSmall?.copyWith(color: backgroundColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () => {
                                    context.pushNamed(
                                      'user-profile',
                                      pathParameters: {
                                        'userId': drop!.user!.id.toString(),
                                      },
                                    ),
                                  },
                                  child: Text(
                                    drop!.user!.username ?? '',
                                    style: textTheme.titleMedium,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width - 126,
                                      child: Text(
                                        drop!.description ?? '',
                                        maxLines : 2,
                                        overflow : TextOverflow.ellipsis,
                                        style: textTheme.bodySmall,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () async {
                                final Uri url;
                                url = Uri.parse(drop!.content ?? '');

                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url);
                                } else {
                                  snackBarWidget(
                                    message: 'Could not launch link',
                                    context: context
                                  );
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width - 126,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CachedImageWidget(
                                      width: 56,
                                      height: 56,
                                      borderRadius: BorderRadius.circular(16),
                                      imageUrl: drop!.contentPicturePath ?? '',
                                    ),
                                    const SizedBox(width: 12),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            drop!.type ?? '',
                                            style: textTheme.titleMedium,
                                            overflow : TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            drop!.contentTitle ?? '',
                                            style: textTheme.bodySmall,
                                            maxLines : 2,
                                            overflow : TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () => {
                                  context.pushNamed(
                                    'user-profile',
                                    pathParameters: {
                                      'userId': drop!.user!.id.toString(),
                                    },
                                  ),
                                },
                                child: (drop!.user!.avatar != null) ? GestureDetector(
                                  onTap: () => {},
                                  child: CachedImageWidget(
                                    imageUrl: drop!.user!.avatar ?? '',
                                    width: 30,
                                    height: 30,
                                    borderRadius: BorderRadius.circular(12),
                                  )
                                ) : ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: SvgPicture.asset(
                                    'lib/assets/images/avatar.svg',
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              LikeBtn(
                                dropId: drop!.id!,
                                isLiked: drop!.isCurrentUserLiking ?? false,
                              ),
                              IconButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                ),
                                onPressed: () => _openCommentSheet(context, drop!.id!, drop!.comments, drop!.totalComments),
                                icon: const Icon(
                                  Icons.mode_comment,
                                ),
                              ),
                              if(drop?.user?.id != BlocProvider.of<AuthBloc>(context).state.auth!.id) IconButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                ),
                                onPressed: () => {
                                  context.pushNamed(
                                    'report',
                                    extra: {
                                      'dropId': drop!.id!.toString(),
                                    }
                                  )
                                },
                                icon: const Icon(
                                  Icons.flag_rounded,
                                ),
                              ),
                              if(drop?.user?.id == BlocProvider.of<AuthBloc>(context).state.auth!.id) PinBtn(
                                dropId: drop!.id!,
                                isPinned: drop!.isPinned ?? false,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          BlocConsumer<HasDroppedBloc, HasDroppedState>(
            listener: (context, hasDroppedState) {},
            builder: (context, hasDroppedState) {
              if(hasDroppedState is HasDroppedWebSocketMessageLoadingReceived
                || hasDroppedState is HasDroppedWebSocketMessageState
                && (hasDroppedState.hasDropped != null
                && hasDroppedState.hasDropped! == false)) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight - 50,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(46),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        color: onPrimaryColor.withOpacity(0.3),
                        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 26),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.visibility_off_rounded,
                                color: secondaryTextColor,
                                size: 50,
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: 230,
                                child: Text(
                                  'Post ton drop du jour pour voir les drops de tes amis !',
                                  textAlign: TextAlign.center,
                                  style: textTheme.labelMedium?.copyWith(
                                    color: secondaryTextColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => {
                                  context.pushNamed('add-drop')
                                },
                                child: Text(
                                  'Poster un Drop',
                                  style: textTheme.labelMedium?.copyWith(
                                    color: backgroundColor,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
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
    );
  }

  void _openCommentSheet(context, dropId, comments, totalComments) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(46),
          topRight: Radius.circular(46),
        ),
      ),
      context: context,
      builder: (context) => CommentSheet(
        dropId: dropId,
        comments: comments,
        totalComments: totalComments,
      )
    );
  }

  void _onTap() {
    if (onDropPressed != null) {
      onDropPressed!(drop!);
    }
  }
}