import 'dart:ui';
import 'package:droppy/config/theme/color.dart';
import 'package:droppy/features/domain/entities/drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/widgets/text.dart';
import '../atoms/cached_image_widget.dart';

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
                                Container(
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
                                        'Paris',
                                        style: textTheme.labelSmall?.copyWith(color: backgroundColor),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () => {
                                    context.goNamed(
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
                                    Text(
                                      drop!.description?? '',
                                      maxLines : 2,
                                      overflow : TextOverflow.ellipsis,
                                      style: textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CachedImageWidget(
                                  width: 56,
                                  height: 56,
                                  borderRadius: BorderRadius.circular(16),
                                  imageUrl: drop!.picturePath ?? '',
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
                                  context.goNamed(
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
                                    borderRadius: BorderRadius.circular(11),
                                  )
                                ) : ClipRRect(
                                  borderRadius: BorderRadius.circular(11),
                                  child: SvgPicture.asset(
                                    'lib/assets/images/avatar.svg',
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              IconButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                ),
                                onPressed: _onTap,
                                icon: const Icon(
                                  Icons.favorite,
                                ),
                              ),
                              IconButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                ),
                                onPressed: _onTap,
                                icon: const Icon(
                                  Icons.mode_comment,
                                ),
                              ),
                              IconButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                ),
                                onPressed: _onTap,
                                icon: const Icon(
                                  Icons.flag_rounded,
                                ),
                              ),
                              if(false) IconButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                ),
                                onPressed: _onTap,
                                icon: const Icon(
                                  Icons.bookmark,
                                ),
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
        ],
      ),
    );
  }

  void _onTap() {
    if (onDropPressed != null) {
      onDropPressed!(drop!);
    }
  }
}