import 'package:droppy/config/theme/color.dart';
import 'package:droppy/features/domain/entities/drop.dart';
import 'package:droppy/features/domain/entities/group.dart';
import 'package:droppy/features/presentation/widgets/atoms/warning_card.dart';
import 'package:droppy/features/presentation/widgets/molecules/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/widgets/text.dart';
import 'drop_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DropFeedWidget extends StatefulWidget {
  final List<DropEntity?> ? drops;
  final GroupEntity ? group;
  final String? username;

  const DropFeedWidget({
    super.key,
    this.drops,
    this.group,
    this.username,
  });

  @override
  State<DropFeedWidget> createState() => _DropFeedWidgetState();
}

class _DropFeedWidgetState extends State<DropFeedWidget> {
  List<DropEntity?> feed = [];

  @override
  void initState() {
    super.initState();
    if (widget.drops != null) {
      setState(() {
        feed = widget.drops!.cast<DropEntity?>();
      });
    } else if (widget.group != null && widget.group?.drops != null) {
      setState(() {
        feed = widget.group!.drops!.cast<DropEntity?>();
      });
    }

  }

  @override
  Widget build(BuildContext context) {

    final FixedExtentScrollController fixedExtentScrollController = FixedExtentScrollController();

    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight - 10,
          child: Stack(
            children: [
              if (feed.isNotEmpty) ListWheelScrollView(
                controller: fixedExtentScrollController,
                physics: const FixedExtentScrollPhysics(),
                overAndUnderCenterOpacity: 0,
                itemExtent: MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight - 50,
                children: feed.map((drop) {
                  return DropTileWidget(
                    drop: drop,
                    onDropPressed: (drop) {
                      context.pushNamed('drop', pathParameters: {'dropId': drop.id.toString()});
                    },
                  );
                }).toList()
              ),
              if (feed.isEmpty) Container(
                height: MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight - 10,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WarningCard(
                        message: AppLocalizations.of(context)!.noDrops,
                        icon: 'empty'
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.pushNamed('add-drop');
                        },
                        child: Text(
                          AppLocalizations.of(context)!.postADrop,
                          style: textTheme.labelMedium?.copyWith(
                            color: backgroundColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 30,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: backgroundColor.withOpacity(0.8),
                      offset: const Offset(0, -15),
                      spreadRadius: 30,
                      blurRadius: 30,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: AppBarWidget(
                  leadingIcon: Icon(
                      (widget.group == null) ? Icons.person_add_rounded : Icons.arrow_back_rounded
                  ),
                  leadingOnPressed: () => {
                    if (widget.group == null) {
                      context.pushNamed('users')
                    } else {
                      context.pop()
                    }
                  },
                  mainActionIcon: const Icon(Icons.notifications_rounded),
                  isMainActionActive: true,
                  mainActionOnPressed: () {
                    context.pushNamed('notification');
                  },
                ),
              ),
              Positioned(
                child: Padding(
                  padding: const EdgeInsets.only(top: 34),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 230,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (widget.group != null) {
                                    context.pushNamed(
                                      AppLocalizations.of(context)!.groups,
                                      pathParameters: {
                                        'groupId': widget.group!.id.toString()
                                      }
                                    );
                                  }
                                },
                                child: Text(
                                  (widget.group?.name ?? (widget.username ?? AppLocalizations.of(context)!.friends)),
                                  style: Theme.of(context).textTheme.headlineMedium,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}