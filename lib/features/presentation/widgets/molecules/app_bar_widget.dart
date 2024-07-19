import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../config/theme/widgets/button.dart';
import '../../../../../config/theme/widgets/text.dart';
import '../../../../config/theme/color.dart';
import '../../bloc/follow/pending/pending_follow_bloc.dart';
import '../../bloc/follow/pending/pending_follow_event.dart';
import '../../bloc/follow/pending/pending_follow_state.dart';

class AppBarWidget extends StatefulWidget {
  final Icon? leadingIcon;
  final Function? leadingOnPressed;
  final String? title;
  final Icon? mainActionIcon;
  final Function? mainActionOnPressed;
  final Icon? secondaryActionIcon;
  final Function? secondaryActionOnPressed;
  final Widget? actionWidget;
  final bool isMainActionActive;

  const AppBarWidget({
    super.key,
    this.leadingIcon,
    this.leadingOnPressed,
    this.title,
    this.mainActionIcon,
    this.mainActionOnPressed,
    this.secondaryActionIcon,
    this.secondaryActionOnPressed,
    this.actionWidget,
    this.isMainActionActive = false,
  });

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (widget.leadingIcon != null) IconButton(
                  icon: widget.leadingIcon!,
                  onPressed: () => _onPressedHandler(
                    context,
                    (widget.leadingOnPressed != null) ?
                      widget.leadingOnPressed! :
                      () {context.pop();}
                  ),
                  style: iconButtonThemeData.style?.copyWith(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                if (widget.title != null) SizedBox(
                  width: MediaQuery.of(context).size.width - 200,
                  child: Text(
                      widget.title!,
                      style: textTheme.headlineMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                if (widget.secondaryActionIcon != null && widget.secondaryActionOnPressed != null) IconButton(
                  icon: widget.secondaryActionIcon!,
                  onPressed: () => _onPressedHandler(context, widget.secondaryActionOnPressed!()),
                  style: iconButtonThemeData.style?.copyWith(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                if (widget.secondaryActionIcon != null && widget.mainActionIcon != null) const SizedBox(width: 8),
                if (widget.mainActionIcon != null && widget.mainActionOnPressed != null) Stack(
                  children: [
                    IconButton(
                      icon: widget.mainActionIcon!,
                      onPressed: () => _onPressedHandler(context, widget.mainActionOnPressed!),
                      style: iconButtonThemeData.style?.copyWith(
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    if (widget.isMainActionActive) BlocConsumer<PendingFollowBloc, PendingFollowState>(
                      listener: (BuildContext context, PendingFollowState state) {},
                      builder: (_, state) {
                        if(state is PendingFollowWebSocketMessageState || state is PendingFollowWebSocketMessageReceived) {
                          if (state.follows!.isNotEmpty) {
                            return Positioned(
                              right: 4,
                              top: 4,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle,
                                ),
                              )
                            );
                          } else {
                            return const SizedBox();
                          }
                        }
                        return const SizedBox();
                      },
                    ),
                  ],
                ),
                if (widget.actionWidget != null) const SizedBox(width: 8),
                if (widget.actionWidget != null) widget.actionWidget!,
              ]
            )
          ],
        ),
      )
    );
  }
}

void _onPressedHandler(BuildContext context, Function onPressed) {
  onPressed();
}
