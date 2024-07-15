import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../config/theme/color.dart';
import '../../../../injection_container.dart';
import '../../bloc/like/like_bloc.dart';
import '../../bloc/like/like_event.dart';
import '../../bloc/like/like_state.dart';

class LikeBtn extends StatefulWidget {
  final int dropId;
  final bool isLiked;

  const LikeBtn({
    super.key,
    required this.dropId,
    this.isLiked = false,
  });

  @override
  State<LikeBtn> createState() => _LikeBtnState();
}

class _LikeBtnState extends State<LikeBtn> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LikesBloc>(
      create: (context) => sl(),
      child: BlocConsumer<LikesBloc, LikesState>(
        listener: (context, state){},
        builder: (context, state) {
          bool isLiked = widget.isLiked;

          if (state is DeleteLikeDone) {
            isLiked = false;
          } else if (state is PostLikeDone && state.drop?.id == widget.dropId) {
            isLiked = true;
          }

          return IconButton(
            onPressed: () {
              if (isLiked) {
                BlocProvider.of<LikesBloc>(context).add(
                    DeleteLike({'id': widget.dropId}));
              } else {
                BlocProvider.of<LikesBloc>(context).add(
                    PostLike({'id': widget.dropId}));
              }
            },
            icon: Icon(
              Icons.favorite,
              color: isLiked ? primaryColor : onSurfaceColor,
            ),
          );
        },
      ),
    );
  }
}