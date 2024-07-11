import 'package:droppy/config/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../config/theme/widgets/text.dart';
import 'cached_image_widget.dart';
import 'comment_response.dart';

class Comment extends StatelessWidget {
  final String? avatar;
  final String? message;
  final String? username;
  final Function? onTap;
  final int? commentId;
  final int? dropId;

  const Comment({
    Key? key,
    this.avatar,
    this.message,
    this.username,
    this.onTap,
    this.commentId,
    this.dropId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(avatar != null) CachedImageWidget(
              imageUrl: avatar ?? '',
              width: 30,
              height: 30,
              borderRadius: BorderRadius.circular(12),
              fit: BoxFit.fitWidth
          ) else ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SvgPicture.asset(
              'lib/assets/images/avatar.svg',
              width: 30,
              height: 30,
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
                  width: MediaQuery.of(context).size.width - 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Reply',
                            style: textTheme.labelSmall?.copyWith(
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Text(
                            'Voir 4 réponses',
                            style: textTheme.labelSmall?.copyWith(
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Icon(
                          Icons.flag_rounded,
                          size: 16,
                          color: onSurfaceColor,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Column(
                  children: List.generate(3, (index) {
                    return const CommentResponse(
                      avatar: null,
                      message: 'This is a comment',
                      username: 'Username',
                      commentResponseId: 1,
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}