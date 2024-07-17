import 'package:droppy/features/presentation/bloc/group/goup_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/color.dart';
import '../../../../config/theme/widgets/text.dart';
import '../../../../injection_container.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/group/group_event.dart';
import '../../bloc/group/group_state.dart';
import '../../bloc/group_member/goup_member_bloc.dart';
import '../../bloc/group_member/group_member_event.dart';
import '../../bloc/group_member/group_member_state.dart';
import '../../widgets/atoms/cached_image_widget.dart';
import '../../widgets/atoms/group_header.dart';
import '../../widgets/atoms/list_items_widget.dart';
import '../../widgets/atoms/snack_bar.dart';
import '../../widgets/atoms/tile_item_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GroupView extends StatefulWidget {
  final String? groupId;

  const GroupView({
    super.key,
    this.groupId
  });

  @override
  State<GroupView> createState() => _GroupViewState();

}

class _GroupViewState extends State<GroupView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    BlocProvider.of<GroupsBloc>(context).add(
      GetGroup({
        'id':int.parse(widget.groupId ?? '')
      })
    );

    return Scaffold(
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<GroupMembersBloc>(
              create: (context) => sl(),
            ),
          ],
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<GroupsBloc , GroupsState>(
                  builder: (context, state) {
                    if (state is GroupDone ) {
                      return GroupHeader(
                        group: state.group,
                      );
                    }
                    return SizedBox(
                      height: MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight - 10,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(child: CircularProgressIndicator()),
                        ],
                      ),
                    );
                  },
                ),
                BlocBuilder<GroupsBloc , GroupsState>(
                  builder: (context, state) {
                    if (state is GroupDone) {
                      return SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (state.group?.description != null) Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24, top: 36, bottom: 0),
                              child: Text(
                                AppLocalizations.of(context)!.description,
                                style: textTheme.titleMedium
                              )
                            ),
                            if (state.group?.description != null) Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 0),
                              child: Text(
                                state.group?.description ?? '',
                                style: textTheme.bodyMedium
                              )
                            ),
                            BlocConsumer<GroupMembersBloc, GroupMembersState>(
                              listener: (context, state) {
                                if(state is LeaveGroupDone) {
                                  snackBarWidget(
                                    message: AppLocalizations.of(context)!.youHaveLeftTheGroup,
                                    context: context,
                                  );

                                  context.pop();
                                }

                                if(state is LeaveGroupError) {
                                  snackBarWidget(
                                    message: AppLocalizations.of(context)!.error,
                                    context: context,
                                    type: 'error',
                                  );
                                }
                              },
                              builder: (context, state) {
                                return const SizedBox(height: 0,);
                              },
                            ),
                            if(state.group?.isPrivate == false || state.group!.groupMembers!.where((element) => element.member?.id == BlocProvider.of<AuthBloc>(context).state.auth?.id).isNotEmpty) Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24, top: 10, bottom: 10),
                              child: ((state.group!.groupMembers!.where((element) => element.member?.id == BlocProvider.of<AuthBloc>(context).state.auth?.id).isNotEmpty
                                && state.group!.groupMembers!.where((element) => element.member?.id == BlocProvider.of<AuthBloc>(context).state.auth?.id).first.role == 'manager')
                                || state.group!.createdBy?.id == BlocProvider.of<AuthBloc>(context).state.auth?.id) ? ListItemsWidget(
                                title: AppLocalizations.of(context)!.members,
                                children: [
                                  if((state.group!.groupMembers!.where((element) => element.member?.id == BlocProvider.of<AuthBloc>(context).state.auth?.id).isNotEmpty
                                    && state.group!.groupMembers!.where((element) => element.member?.id == BlocProvider.of<AuthBloc>(context).state.auth?.id).first.role == 'manager')
                                    || state.group!.createdBy?.id == BlocProvider.of<AuthBloc>(context).state.auth?.id) TileItemWidget(
                                    title: AppLocalizations.of(context)!.manageMembers,
                                    leadingIcon: const Icon(
                                        Icons.person_add_rounded,
                                        color: textColor
                                    ),
                                    onTap: () {
                                      context.pushNamed(
                                        'group-members-list',
                                        pathParameters: {
                                          'groupId': state.group?.id.toString() ?? '',
                                        },
                                      );
                                    },
                                  ),
                                  if(state.group!.createdBy?.id != BlocProvider.of<AuthBloc>(context).state.auth?.id
                                    && state.group!.groupMembers!.where((element) => element.member?.id == BlocProvider.of<AuthBloc>(context).state.auth?.id).isNotEmpty) TileItemWidget(
                                    title: AppLocalizations.of(context)!.leaveGroup,
                                    titleColor: errorColor,
                                    leadingIcon: const Icon(
                                        Icons.logout_rounded,
                                        color: errorColor
                                    ),
                                    onTap: () {
                                      BlocProvider.of<GroupMembersBloc>(context).add(LeaveGroup({
                                        'id': int.parse(widget.groupId ?? '0'),
                                        'memberId': BlocProvider.of<AuthBloc>(context).state.auth?.id ?? 0
                                      }));
                                    },
                                  ),
                                ],
                              ) : Padding(
                                padding: const EdgeInsets.only(top:28),
                                child: Text(
                                  AppLocalizations.of(context)!.members,
                                  style: textTheme.titleMedium
                                ),
                              ),
                            ),
                            if (state.group?.groupMembers != null) ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.group?.groupMembers?.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () => {
                                    context.pushNamed(
                                      'user-profile',
                                      pathParameters: {
                                        'userId': state.group?.groupMembers?[index].member?.id.toString() ?? '',
                                      },
                                    )
                                  },
                                  leading: state.group?.groupMembers?[index].member?.avatar != null ? CachedImageWidget(
                                    borderRadius: BorderRadius.circular(16),
                                    imageUrl: state.group?.groupMembers?[index].member?.avatar ?? '',
                                    height: 50,
                                    width: 50,
                                  ) : ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: SvgPicture.asset(
                                      'lib/assets/images/avatar.svg',
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          state.group?.groupMembers?[index].member?.username ?? '',
                                          style: Theme.of(context).textTheme.titleMedium
                                      ),
                                      if (state.group?.groupMembers?[index].role != 'member') Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(7),
                                          color: onPrimaryColor.withOpacity(0.4),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        child: Text(
                                          state.group?.groupMembers?[index].role ?? '',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                             fontSize: 11
                                          )
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(
                                    state.group?.groupMembers?[index].member?.bio ?? '',
                                  ),
                                );
                              }
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}