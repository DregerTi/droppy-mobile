import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../config/theme/color.dart';
import '../../../../../config/theme/widgets/button.dart';
import '../../../data/models/like.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/drop/drop_bloc.dart';
import '../../bloc/drop/drop_event.dart';
import '../../bloc/like/like_bloc.dart';
import '../../bloc/like/like_event.dart';
import '../../bloc/like/like_state.dart';

class LikeBtn extends StatefulWidget {
  final int dropId;
  final LikeModel? like;

  const LikeBtn({
    Key? key,
    required this.dropId,
    this.like,
  }) : super(key: key);

  @override
  State<LikeBtn> createState() => _LikeBtnState();
}

class _LikeBtnState extends State<LikeBtn> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: BlocBuilder<LikesBloc, LikesState>(
        builder: (context, state) {
          if (state is DeleteLikeDone){
            BlocProvider.of<DropsBloc>(context).add(UpdateLoadedDropsCurrentUserLike({
              'like': state.like,
              'action': 'post',
            }));
            return IconButton(
              onPressed: () => {
                if (BlocProvider.of<AuthBloc>(context).state is AuthDone) {
                  BlocProvider.of<LikesBloc>(context).add(PostLike({
                    'drop': '/drops/${widget.dropId}',
                  }))
                } else {
                  context.goNamed('sign-in'),
                }
              },
              icon: const Icon(Icons.favorite_outline_rounded),
              style: iconButtonThemeData.style?.copyWith(
                backgroundColor: MaterialStateProperty.all<Color>(surfaceColor),
                foregroundColor: MaterialStateProperty.all<Color>(onSurfaceColor),
              ),
            );
          }

          if(state is PostLikeDone){
            BlocProvider.of<DropsBloc>(context).add(UpdateLoadedDropsCurrentUserLike({
              'like': state.like,
              'action': 'delete',
            }));
            return IconButton(
              onPressed: () => {
                if (BlocProvider.of<AuthBloc>(context).state is AuthDone) {
                  BlocProvider.of<LikesBloc>(context).add(DeleteLike({
                    'likeId': state.like?.id,
                  }))
                } else {
                  context.goNamed('sign-in'),
                }
              },
              icon: const Icon(
                Icons.favorite_rounded,
                color: primaryColor,
              ),
              style: iconButtonThemeData.style?.copyWith(
                backgroundColor: MaterialStateProperty.all<Color>(surfaceColor),
                foregroundColor: MaterialStateProperty.all<Color>(onSurfaceColor),
              ),
            );
          }

          return IconButton(
            onPressed: () => {
              if (BlocProvider.of<AuthBloc>(context).state is AuthDone) {
                if(widget.like == null){
                  BlocProvider.of<LikesBloc>(context).add(PostLike({
                    'drop': '/drops/${widget.dropId}',
                  }))
                } else {
                  BlocProvider.of<LikesBloc>(context).add(DeleteLike({
                    'likeId': widget.like?.id,
                  }))
                }
              } else {
                context.goNamed('sign-in'),
              }
            },
            icon: Icon(
              widget.like != null ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
              color: widget.like != null ? primaryColor : null,
            ),
            style: iconButtonThemeData.style?.copyWith(
              backgroundColor: MaterialStateProperty.all<Color>(surfaceColor),
              foregroundColor: MaterialStateProperty.all<Color>(onSurfaceColor),
            ),
          );
        },
      ),
    );
  }
}