import 'package:droppy/config/theme/color.dart';
import 'package:droppy/features/domain/entities/drop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
            borderRadius: BorderRadius.circular(28),
            imageUrl: drop!.picturePath ?? "https://i.pinimg.com/originals/48/5f/4f/485f4f34c6074ad220612c1c908d8523.jpg",
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight - 50,
          ),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: backgroundColor.withOpacity(0.5),
                  spreadRadius: 60,
                  blurRadius: 60,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: backgroundColor.withOpacity(0.5),
                    spreadRadius: 60,
                    blurRadius: 60,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight - 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: CachedImageWidget(
                            borderRadius: BorderRadius.circular(10),
                            imageUrl: drop!.user!.avatar ?? "https://i.pinimg.com/originals/48/5f/4f/485f4f34c6074ad220612c1c908d8523.jpg",
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ),
                      Text(
                        drop!.user!.username ?? '',
                        style: textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            drop!.description?? '',
                            maxLines : 2,
                            overflow : TextOverflow.ellipsis,
                            style: textTheme.titleMedium
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: onSurfaceColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.favorite, color: primaryColor, size: 26),
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
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                ),
                                onPressed: _onTap,
                                icon: const Icon(
                                  Icons.favorite_border,
                                  size: 26,
                                  color: textColor,
                                ),
                              ),
                              IconButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                ),
                                onPressed: _onTap,
                                icon: const Icon(
                                  Icons.share,
                                  size: 26,
                                  color: textColor,
                                ),
                              ),
                              IconButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                ),
                                onPressed: _onTap,
                                icon: const Icon(
                                  Icons.comment,
                                  size: 26,
                                  color: textColor,
                                ),
                              ),
                              IconButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                ),
                                onPressed: _onTap,
                                icon: const Icon(
                                  Icons.save,
                                  size: 26,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
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