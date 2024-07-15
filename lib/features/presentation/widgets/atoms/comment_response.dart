import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/color.dart';
import '../../../../config/theme/widgets/text.dart';
import 'cached_image_widget.dart';

class CommentResponse extends StatelessWidget {
  final String? avatar;
  final String? message;
  final String? username;
  final Function? onTap;
  final int? commentResponseId;

  const CommentResponse({
    Key? key,
    this.avatar,
    this.message,
    this.username,
    this.onTap,
    this.commentResponseId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(avatar != null) CachedImageWidget(
              imageUrl: avatar ?? '',
              width: 26,
              height: 26,
              borderRadius: BorderRadius.circular(10),
              fit: BoxFit.fitWidth
          ) else ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SvgPicture.asset(
              'lib/assets/images/avatar.svg',
              width: 26,
              height: 26,
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              if(onTap != null){
                onTap!();
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      username ?? 'Anonyme',
                      style: textTheme.labelSmall?.copyWith(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '12-12-2021',
                      style: textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                if(message != null) Text(
                  message!,
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 2),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 116,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.pushNamed(
                              'report',
                              extra: {
                                'commentResponseId': commentResponseId.toString(),
                              }
                          );
                        },
                        child: const Icon(
                          Icons.flag_rounded,
                          size: 16,
                          color: onSurfaceColor,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}