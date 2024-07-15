import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../config/theme/color.dart';
import '../../../../injection_container.dart';
import '../../bloc/pin_drop/pin_drop_bloc.dart';
import '../../bloc/pin_drop/pin_drop_event.dart';
import '../../bloc/pin_drop/pin_drop_state.dart';

class PinBtn extends StatefulWidget {
  final int dropId;
  final bool isPinned;

  const PinBtn({
    super.key,
    required this.dropId,
    this.isPinned = false,
  });

  @override
  State<PinBtn> createState() => _PinBtnState();
}

class _PinBtnState extends State<PinBtn> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PinDropBloc>(
      create: (context) => sl(),
      child: BlocConsumer<PinDropBloc, PinDropState>(
        listener: (context, state){},
        builder: (context, state) {
          bool isPinned = widget.isPinned;

          if (state is DeletePinDropDone) {
            isPinned = false;
          } else if (state is PostPinDropDone && state.drop?.id == widget.dropId) {
            isPinned = true;
          }

          return IconButton(
            onPressed: () {
              if (!isPinned) {
                BlocProvider.of<PinDropBloc>(context).add(
                  PostPinDrop({'id': widget.dropId}));
              } else {
                BlocProvider.of<PinDropBloc>(context).add(
                  DeletePinDrop({'id': widget.dropId}));
              }
            },
            icon: Icon(
              Icons.bookmark_rounded,
              color: isPinned ? primaryColor : onSurfaceColor,
            ),
          );
        },
      ),
    );
  }
}