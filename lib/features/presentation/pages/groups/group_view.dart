import 'package:droppy/config/theme/widgets/button.dart';
import 'package:droppy/features/data/models/group_member.dart';
import 'package:droppy/features/presentation/bloc/group/goup_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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

  const GroupView({super.key, this.groupId});

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
    BlocProvider.of<GroupsBloc>(context)
        .add(GetGroup({'id': int.parse(widget.groupId ?? '')}));

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
                BlocBuilder<GroupsBloc, GroupsState>(
                  builder: (context, state) {
                    if (state is GroupDone) {
                      return GroupHeader(
                        group: state.group,
                      );
                    }
                    return SizedBox(
                      height: MediaQuery.of(context).size.height - 50,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(child: CircularProgressIndicator()),
                        ],
                      ),
                    );
                  },
                ),
                BlocBuilder<GroupsBloc, GroupsState>(
                  builder: (context, state) {
                    if (state is GroupDone) {
                      final currentUser =
                          BlocProvider.of<AuthBloc>(context).state.auth?.id;
                      final groupMembers = state.group?.groupMembers ?? [];
                      final isManager =
                          state.group?.createdBy?.id == currentUser ||
                              groupMembers.any((member) =>
                                  member.member?.id == currentUser &&
                                  member.role == 'manager');
                      final isOwner = state.group?.createdBy?.id == currentUser;
                      final currentUserManager = groupMembers.any((member) =>
                          member.member?.id == currentUser &&
                          member.role == 'manager');

                      return SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (state.group?.description != null)
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 24, right: 24, top: 36, bottom: 0),
                                  child: Text(
                                      AppLocalizations.of(context)!.description,
                                      style: textTheme.titleMedium)),
                            if (state.group?.description != null)
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 24, right: 24, top: 8, bottom: 0),
                                  child: Text(state.group?.description ?? '',
                                      style: textTheme.bodyMedium)),
                            BlocConsumer<GroupMembersBloc, GroupMembersState>(
                              listener: (context, state) {
                                if (state is UpdateManagerDone) {
                                  snackBarWidget(
                                    message: "Manager updated",
                                    context: context,
                                  );
                                  BlocProvider.of<GroupsBloc>(context).add(
                                      GetGroup({
                                    'id': int.parse(widget.groupId ?? '')
                                  }));
                                }
                                if (state is UpdateManagerError) {
                                  snackBarWidget(
                                    message:
                                        AppLocalizations.of(context)!.error,
                                    context: context,
                                    type: 'error',
                                  );
                                }
                                if (state is LeaveGroupDone) {
                                  snackBarWidget(
                                    message: AppLocalizations.of(context)!
                                        .youHaveLeftTheGroup,
                                    context: context,
                                  );

                                  context.pop();
                                  context.pop();
                                }

                                if (state is LeaveGroupError) {
                                  snackBarWidget(
                                    message:
                                        AppLocalizations.of(context)!.error,
                                    context: context,
                                    type: 'error',
                                  );
                                }
                              },
                              builder: (context, state) {
                                return const SizedBox(
                                  height: 0,
                                );
                              },
                            ),
                            if (state.group?.isPrivate == false ||
                                groupMembers.any((element) =>
                                    element.member?.id == currentUser))
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 24, right: 24, top: 10, bottom: 10),
                                child: (isManager || isOwner)
                                    ? ListItemsWidget(
                                        title: AppLocalizations.of(context)!
                                            .members,
                                        children: [
                                          if (isManager || isOwner)
                                            TileItemWidget(
                                              title:
                                                  AppLocalizations.of(context)!
                                                      .manageMembers,
                                              leadingIcon: const Icon(
                                                  Icons.person_add_rounded,
                                                  color: textColor),
                                              onTap: () {
                                                context.pushNamed(
                                                  'group-members-list',
                                                  pathParameters: {
                                                    'groupId': state.group?.id
                                                            .toString() ??
                                                        '',
                                                  },
                                                );
                                              },
                                            ),
                                          if (!isOwner &&
                                              groupMembers.any((element) =>
                                                  element.member?.id ==
                                                  currentUser))
                                            TileItemWidget(
                                              title:
                                                  AppLocalizations.of(context)!
                                                      .leaveGroup,
                                              titleColor: errorColor,
                                              leadingIcon: const Icon(
                                                  Icons.logout_rounded,
                                                  color: errorColor),
                                              onTap: () {
                                                BlocProvider.of<
                                                            GroupMembersBloc>(
                                                        context)
                                                    .add(LeaveGroup({
                                                  'id': int.parse(
                                                      widget.groupId ?? '0'),
                                                  'memberId': currentUser ?? 0
                                                }));
                                              },
                                            ),
                                        ],
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(top: 28),
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .members,
                                            style: textTheme.titleMedium),
                                      ),
                              ),
                            if (state.group?.groupMembers != null)
                              ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 8),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: groupMembers.length,
                                itemBuilder: (context, index) {
                                  final member = groupMembers[index];
                                  final isUserManager =
                                      member.role == 'manager';
                                  final isCurrentUser =
                                      member.member?.id == currentUser;

                                  // check that the id element is not the creator of the group
                                  final isNotOwner =
                                      state.group!.createdBy?.id !=
                                          member.member?.id;

                                  return currentUserManager
                                      ? Slidable(
                                          key: ValueKey(member.member?.id),
                                          endActionPane: ActionPane(
                                            motion: const DrawerMotion(),
                                            children: [
                                              if (!isUserManager)
                                                SlidableAction(
                                                  spacing: 2,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  onPressed: (context) {
                                                    BlocProvider.of<
                                                                GroupMembersBloc>(
                                                            context)
                                                        .add(SetManager({
                                                      'groupId':
                                                          state.group?.id,
                                                      'memberId':
                                                          member.member?.id,
                                                    }));
                                                  },
                                                  backgroundColor: primaryColor,
                                                  foregroundColor: textColor,
                                                  icon: Icons.person_add,
                                                  label: 'Set Manager',
                                                ),
                                              if (isUserManager &&
                                                  isNotOwner &&
                                                  !isCurrentUser)
                                                SlidableAction(
                                                  spacing: 2,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  onPressed: (context) {
                                                    BlocProvider.of<
                                                                GroupMembersBloc>(
                                                            context)
                                                        .add(RemoveManager({
                                                      'groupId':
                                                          state.group?.id,
                                                      'memberId':
                                                          member.member?.id,
                                                    }));
                                                  },
                                                  backgroundColor: errorColor,
                                                  foregroundColor: textColor,
                                                  icon: Icons.person_remove,
                                                  label: 'Remove Manager',
                                                ),
                                            ],
                                          ),
                                          child:
                                              _buildListTile(context, member),
                                        )
                                      : _buildListTile(context, member);
                                },
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

  ListTile _buildListTile(BuildContext context, GroupMemberModel member) {
    return ListTile(
      onTap: () => {
        context.pushNamed(
          'user-profile',
          pathParameters: {
            'userId': member.member?.id.toString() ?? '',
          },
        )
      },
      leading: member.member?.avatar != null
          ? CachedImageWidget(
              borderRadius: BorderRadius.circular(16),
              imageUrl: member.member?.avatar ?? '',
              height: 50,
              width: 50,
            )
          : ClipRRect(
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
          Text(member.member?.username ?? '',
              style: Theme.of(context).textTheme.titleMedium),
          if (member.role != 'member')
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: onPrimaryColor.withOpacity(0.4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: Text(member.role ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 11)),
            ),
        ],
      ),
      subtitle: Text(
        member.member?.bio ?? '',
      ),
    );
  }
}
