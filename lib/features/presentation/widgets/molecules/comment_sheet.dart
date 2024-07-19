import 'package:droppy/config/theme/widgets/text.dart';
import 'package:droppy/features/presentation/bloc/comment/comment_bloc.dart';
import 'package:droppy/features/presentation/bloc/comment/comment_state.dart';
import 'package:droppy/features/presentation/widgets/atoms/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../config/theme/color.dart';
import '../../../../injection_container.dart';
import '../../../data/models/comment.dart';
import '../../bloc/comment/comment_event.dart';
import '../atoms/comment.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommentSheet extends StatefulWidget {
  final List<CommentModel>? comments;
  final int? totalComments;
  final int? dropId;

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
  bool isCommentResponse = false;
  int? responseCommentCommentId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CommentsBloc>(
      create: (context) => sl(),
      child: Container(
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
                      '${widget.totalComments} ${AppLocalizations.of(context)!.comment}',
                      style: textTheme.labelMedium,
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          children: List.generate(widget.comments!.length, (index) {
                            return Comment(
                              onTap: () {
                                context.pushNamed(
                                    'user-profile',
                                    pathParameters: {
                                      'userId': widget.comments![index].user!.id.toString()
                                    }
                                );
                              },
                              setIsCommentResponse: (value, commentId) {
                                setState(() {
                                  responseCommentCommentId = commentId;
                                  isCommentResponse = value;
                                });
                              },
                              avatar: widget.comments![index].user!.avatar,
                              message: widget.comments![index].content,
                              username: widget.comments![index].user!.username,
                              commentId: widget.comments![index].id,
                              commentResponses: widget.comments![index].commentResponses,
                              dropId: widget.dropId,
                              createdAt: widget.comments![index].createdAt,
                            );
                          }),
                        ),
                      ),
                    ),
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
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: commentController,
                        decoration: InputDecoration(
                          suffixIcon: BlocConsumer<CommentsBloc, CommentsState>(
                            listener: (context, state) {
                              if (state is PostCommentDone || state is PostCommentResponseDone) {
                                commentController.clear();
                                Navigator.pop(context, true);
                                snackBarWidget(
                                  message: AppLocalizations.of(context)!.commentSent,
                                  context: context,
                                );
                              }

                              if (state is PostCommentError || state is PostCommentResponseError) {
                                snackBarWidget(
                                  message: AppLocalizations.of(context)!.errorSendingComment,
                                  type: 'error',
                                  context: context,
                                );
                              }
                            },
                            builder: (context, state) {
                              return GestureDetector(
                                onTap: () {
                                  if (commentController.text.isNotEmpty) {
                                    if (isCommentResponse) {
                                      context.read<CommentsBloc>().add(
                                        PostCommentResponse({
                                          'commentId': responseCommentCommentId!,
                                          'commentResponse': {
                                            'content': commentController.text,
                                          },
                                        }),
                                      );
                                    } else {
                                      BlocProvider.of<CommentsBloc>(context).add(
                                        PostComment({
                                          'comment': {
                                            'content': commentController.text,
                                          },
                                          'dropId': widget.dropId,
                                        }),
                                      );
                                    }
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    right: 6,
                                    top: 6,
                                    bottom: 6,
                                    left: 6,
                                  ),
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: onPrimaryColor,
                                    ),
                                    child: (state is PostCommentLoading)
                                        ? const SizedBox(
                                      height: 10,
                                      width: 10,
                                      child: CircularProgressIndicator(),
                                    )
                                        : const Icon(
                                      Icons.arrow_upward_rounded,
                                      size: 20,
                                      color: surfaceColor,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          hintText: isCommentResponse
                              ? AppLocalizations.of(context)!.writeReply
                              : AppLocalizations.of(context)!.writeComment,
                          helperText: '',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
