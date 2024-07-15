import 'package:droppy/config/theme/widgets/text.dart';
import 'package:droppy/features/data/models/group_member.dart';
import 'package:droppy/features/presentation/bloc/follow/get/follow_get_bloc.dart';
import 'package:droppy/features/presentation/bloc/group_member/goup_member_bloc.dart';
import 'package:droppy/features/presentation/bloc/group_member/group_member_state.dart';
import 'package:droppy/features/presentation/widgets/organisms/search_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../../config/theme/color.dart';
import '../../../../config/theme/widgets/button.dart';
import '../../../../injection_container.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/follow/get/follow_get_event.dart';
import '../../bloc/group/goup_bloc.dart';
import '../../bloc/group/group_event.dart';
import '../../bloc/group/group_state.dart';
import '../../bloc/group_member/group_member_event.dart';
import '../../bloc/user/user_bloc.dart';
import '../../widgets/atoms/cached_image_widget.dart';
import '../../widgets/atoms/snack_bar.dart';
import '../../widgets/atoms/warning_card.dart';
import '../../widgets/molecules/app_bar_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GroupMembersView extends StatefulWidget {
  final String? groupId;

  const GroupMembersView({
    super.key,
    this.groupId
  });

  @override
  State<GroupMembersView> createState() => _GroupMembersViewState();
}

class _GroupMembersViewState extends State<GroupMembersView> {
  List<GroupMemberModel> selectedUsers = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
    providers: [
      BlocProvider<UsersBloc>(
        create: (context) => sl(),
      ),
      BlocProvider<GroupMembersBloc>(
        create: (context) => sl(),
      ),
      BlocProvider<GroupsBloc>(
        create: (context) => sl()..add(
          GetGroup({
            'id':int.parse(widget.groupId ?? '')
          })
        ),
      ),
      BlocProvider<FollowGetBloc>(
        create: (context) => sl()..add(GetUserFollowed({
          'id': int.parse(BlocProvider.of<AuthBloc>(context).state.auth!.id.toString())
        })),
      ),
    ],
    child: BlocConsumer<GroupsBloc, GroupsState>(
      listener: (context, state) {
        if(state is GroupDone) {
          List<GroupMemberModel> members = state.group?.groupMembers ?? [];
          members.removeWhere((element) => element.member?.id == BlocProvider.of<AuthBloc>(context).state.auth?.id);
          members.removeWhere((element) => element.member?.id == state.group?.createdBy?.id);

          setState(() {
            selectedUsers = members;
          });
        }
      },
      builder: (context, state) {
        if(state is GroupError) {
          return Center(
            child: WarningCard(
                message: AppLocalizations.of(context)!.loadingError,
                icon: 'error',
                onTap: () {
                  BlocProvider.of<GroupsBloc>(context).add(GetGroup({
                    'id': int.parse(widget.groupId ?? '')
                  }));
                }
            ),
          );
        }

        if(state is GroupDone) {

          return Scaffold(
            backgroundColor: backgroundColor,
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Column(
                    children: [
                      AppBarWidget(
                        title: state.group?.name ?? '',
                        leadingIcon: const Icon(Icons.arrow_back),
                        leadingOnPressed: () {
                          context.pop();
                        },
                      ),
                      BlocConsumer<GroupMembersBloc, GroupMembersState>(
                        listener: (context, state) {
                          if(state is LeaveGroupDone) {
                            snackBarWidget(
                              message: 'Membre supprimé avec succès',
                              context: context,
                            );

                            BlocProvider.of<GroupsBloc>(context).add(GetGroup({
                              'id': int.parse(widget.groupId ?? '')
                            }));
                          }

                          if(state is PostGroupMemberDone) {
                            snackBarWidget(
                              message: 'Membre ajouté avec succès',
                              context: context,
                            );

                            BlocProvider.of<GroupsBloc>(context).add(GetGroup({
                              'id': int.parse(widget.groupId ?? '')
                            }));
                          }

                          if(state is LeaveGroupError) {
                            snackBarWidget(
                              message: 'Erreur lors de la suppression du membre',
                              context: context,
                              type: 'error',
                            );
                          }

                          if(state is PostGroupMemberError) {
                            snackBarWidget(
                              message: 'Erreur lors de l\'ajout du membre',
                              context: context,
                              type: 'error',
                            );
                          }
                        },
                        builder: (context, state) {
                          return const SizedBox(height: 0,);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 0, left: 24, right: 24),
                        child: Column(
                          children: [
                            if (selectedUsers.isNotEmpty) Padding(
                              padding: const EdgeInsets.only(bottom: 0),
                              child: SizedBox(
                                height: 70,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: selectedUsers.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Stack(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 4, right: 4, left: 4),
                                                child: (selectedUsers[index].member?.avatar != null) ? CachedImageWidget(
                                                  imageUrl: selectedUsers[index].member!.avatar!,
                                                  width: 36,
                                                  height: 36,
                                                  borderRadius: BorderRadius.circular(14),
                                                ) : ClipRRect(
                                                  borderRadius: BorderRadius.circular(14),
                                                  child: SvgPicture.asset(
                                                    'lib/assets/images/avatar.svg',
                                                    width: 36,
                                                    height: 36,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    BlocProvider.of<GroupMembersBloc>(context).add(LeaveGroup({
                                                      'id': int.parse(widget.groupId ?? '0'),
                                                      'memberId': selectedUsers[index].member?.id ?? 0
                                                    }));
                                                  },
                                                  child: Container(
                                                    width: 18,
                                                    height: 18,
                                                    decoration: BoxDecoration(
                                                      color: surfaceColor,
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: const Center(
                                                      child: Icon(
                                                        Icons.close_rounded,
                                                        color: onSurfaceColor,
                                                        size: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          SizedBox(
                                            width: 52,
                                            child: Center(
                                              child: Text(
                                                selectedUsers[index].member!.username! ?? '',
                                                overflow: TextOverflow.ellipsis,
                                                style: textTheme.labelSmall?.copyWith(
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SearchUsers(
                          showFollowing: true,
                          onTap: (user) {
                            setState(() {
                              if (selectedUsers.where((element) => element.member?.id == user?.id).isNotEmpty) {
                                snackBarWidget(
                                  message: 'Membre déjà ajouté',
                                  type: 'error',
                                  context: context
                                );
                              } else {
                                BlocProvider.of<GroupMembersBloc>(context).add(PostGroupMember({
                                  'id': int.parse(widget.groupId ?? '0'),
                                  'memberId': user?.id ?? 0
                                }));
                              }
                            });
                          },
                        )
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }

        return SizedBox(
          height: MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight - 30,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: CircularProgressIndicator()),
            ],
          ),
        );
      },
      ),
    );
  }
}