import 'package:droppy/config/theme/widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../config/theme/color.dart';
import '../../../../../config/theme/widgets/button.dart';
import '../../../data/models/comment.dart';
import '../atoms/comment.dart';

class CommentSheet extends StatefulWidget {
  final List<CommentModel>? comments;
  final int ? totalComments;
  final int ? dropId;

  const CommentSheet({
    super.key,
    this.comments,
    this.totalComments,
    this.dropId,
  });

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(46)),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${widget.totalComments} comments',
                    style: textTheme.labelMedium
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        children: List.generate(10, (index) {
                          return const Comment(
                            avatar: null,
                            message: 'This is a comment',
                            username: 'Username',
                            commentId: 1,
                            dropId: 1,
                          );
                        }),
                      ),
                    )
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 10,
                top: 20,
              ),
              decoration: const BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(46),
                  topRight: Radius.circular(46)
                )
              ),
              child: Expanded(
                child: TextFormField(
                  controller: commentController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      style: iconButtonThemeData.style?.copyWith(
                        backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                        iconSize: MaterialStateProperty.all<double>(0),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(1)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                      onPressed: () => {},
                      icon: const Icon(
                        Icons.arrow_upward_rounded,
                        size: 20
                      ),
                    ),
                    hintText: 'Whrite comment',
                    helperText: '',
                  )
                ),
              )
            ),
          )
        ],
      ),
    );
  }
}