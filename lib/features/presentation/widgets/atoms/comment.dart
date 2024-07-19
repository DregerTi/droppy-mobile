import 'package:droppy/config/theme/color.dart';
import 'package:droppy/features/data/models/comment_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/widgets/text.dart';
import 'cached_image_widget.dart';
import 'comment_response.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Comment extends StatelessWidget {
  final String? avatar;
  final String? message;
  final String? username;
  final Function? onTap;
  final int? commentId;
  final int? dropId;
  final DateTime? createdAt;
  final List<CommentResponseModel>? commentResponses;
  final Function? setIsCommentResponse;

  const Comment({
    Key? key,
    this.avatar,
    this.message,
    this.username,
    this.onTap,
    this.commentId,
    this.dropId,
    this.createdAt,
    this.commentResponses,
    this.setIsCommentResponse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (avatar != null)
            GestureDetector(
              onTap: () {
                if (onTap != null) {
                  onTap!();
                }
              },
              child: GestureDetector(
                onTap: () {
                  if (onTap != null) {
                    onTap!();
                  }
                },
                child: CachedImageWidget(
                    imageUrl: avatar ?? '',
                    width: 30,
                    height: 30,
                    borderRadius: BorderRadius.circular(12),
                    fit: BoxFit.fitWidth),
              ),
            )
          else
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SvgPicture.asset(
                'lib/assets/images/avatar.svg',
                width: 30,
                height: 30,
              ),
            ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (onTap != null) {
                          onTap!();
                        }
                      },
                      child: Text(
                        username ?? 'Anonyme',
                        style: textTheme.labelSmall?.copyWith(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      createdAt != null
                          ? '${createdAt!.day}/${createdAt!.month}/${createdAt!.year}'
                          : '',
                      style: textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                if (message != null)
                  Text(
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
                          GestureDetector(
                            onTap: () {},
                            child: GestureDetector(
                              onTap: () {
                                if (setIsCommentResponse != null) {
                                  setIsCommentResponse!(true, commentId);
                                } else {
                                  setIsCommentResponse!(false, commentId);
                                }
                              },
                              child: Text(
                                AppLocalizations.of(context)!.reply,
                                style: textTheme.labelSmall?.copyWith(
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                          if (commentResponses != null &&
                              commentResponses!.isNotEmpty)
                            const SizedBox(width: 14),
                          if (commentResponses != null &&
                              commentResponses!.isNotEmpty)
                            Text(
                              'Voir réponses ${commentResponses!.length}',
                              style: textTheme.labelSmall?.copyWith(
                                fontSize: 11,
                              ),
                            ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          context.pushNamed('report', extra: {
                            'commentId': commentId.toString(),
                          });
                        },
                        child: const Icon(
                          Icons.flag_rounded,
                          size: 16,
                          color: onSurfaceColor,
                        ),
                      )
                    ],
                  ),
                ),
                if (commentResponses != null && commentResponses!.isNotEmpty)
                  const SizedBox(height: 18),
                if (commentResponses != null && commentResponses!.isNotEmpty)
                  Column(
                    children: List.generate(commentResponses!.length, (index) {
                      return CommentResponse(
                        avatar: commentResponses![index].user!.avatar,
                        message: commentResponses![index].content,
                        username: commentResponses![index].user!.username,
                        commentResponseId: commentResponses![index].id,
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
