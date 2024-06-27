import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/widgets/text.dart';
import 'cached_image_widget.dart';

class Comment extends StatelessWidget {
  final String? profilePicture;
  final String? message;
  final String? username;
  final Function? onTap;
  final int? commentId;
  final int? dropId;

  const Comment({
    Key? key,
    this.profilePicture,
    this.message,
    this.username,
    this.onTap,
    this.commentId,
    this.dropId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(commentId != null){
      return GestureDetector(
        onLongPressDown: (longPressDownDetails) {
          context.goNamed(
            'comment-report',
            pathParameters: {
              'commentId': commentId.toString(),
              'dropId': dropId.toString(),
            },
          );
        },
        child: _buildBody(),
      );
    }
    return _buildBody();
  }

  Widget _buildBody(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            if(onTap != null){
              onTap!();
            }
          },
          child: Row(
            children: [
              CachedImageWidget(
                imageUrl: profilePicture ?? '',
                width: 40,
                height: 40,
                borderRadius: BorderRadius.circular(10),
                fit: BoxFit.fitWidth,
              ),
              const SizedBox(width: 10),
              Text(
                username ?? 'Anonyme',
                style: textTheme.titleMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if(message != null) Text(
          message!,
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}