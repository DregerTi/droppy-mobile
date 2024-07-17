import 'dart:async';
import 'package:droppy/features/presentation/widgets/atoms/warning_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/color.dart';
import '../../bloc/group/goup_bloc.dart';
import '../../bloc/group/group_event.dart';
import '../../bloc/group/group_state.dart';
import '../../bloc/user/user_bloc.dart';
import '../atoms/cached_image_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchGroups extends StatefulWidget {
  final Function? onTap;

  const SearchGroups({
    super.key,
    this.onTap,
  });

  @override
  State<SearchGroups> createState() => _SearchGroupsState();
}

class _SearchGroupsState extends State<SearchGroups> {
  TextEditingController searchFieldController = TextEditingController();
  Timer? debounce;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    debounce?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 26, right: 26, top: 0, bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextFormField(
                  controller: searchFieldController,
                  textInputAction: TextInputAction.search,
                  onChanged: (input) {
                    if (debounce?.isActive ?? false) debounce?.cancel();
                    if (input.isNotEmpty) {
                      debounce = Timer(const Duration(milliseconds: 1000), () {
                        BlocProvider.of<GroupsBloc>(context).add(GetGroups({
                          'search': input,
                        }));
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.joinGroup,
                    suffixIcon: Icon(Icons.search, color: onSurfaceColor, size: 20),
                  )
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: BlocConsumer<GroupsBloc, GroupsState>(
            listener: (BuildContext context, GroupsState state) {  },
            builder: (_,state) {
              if(searchFieldController.text.isEmpty) {
                if(BlocProvider.of<UsersBloc>(context).state.me!.groups!.isNotEmpty) {
                  return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 8),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: BlocProvider.of<UsersBloc>(context).state.me!.groups!.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              if (widget.onTap != null) {
                                widget.onTap!(BlocProvider.of<UsersBloc>(context).state.me!.groups![index]);
                              } else {
                                context.pushNamed(
                                  'user-profile',
                                  pathParameters: {
                                    'userId': BlocProvider.of<UsersBloc>(context).state.me!.groups![index].id
                                        .toString() ?? '',
                                  },
                                );
                              }
                            },
                            leading: BlocProvider.of<UsersBloc>(context).state.me!.groups![index].picturePath != null
                                ? CachedImageWidget(
                              borderRadius: BorderRadius.circular(16),
                              imageUrl: BlocProvider.of<UsersBloc>(context).state.me!.groups![index].picturePath ??
                                  '',
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
                            title: Text(
                                BlocProvider.of<UsersBloc>(context).state.me!.groups![index].name ?? '',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .titleMedium
                            ),
                            subtitle: Text(
                              BlocProvider.of<UsersBloc>(context).state.me!.groups![index].description ?? '',
                              maxLines: 1,
                            ),
                          );
                        },
                      )
                  );
                } else {
                  return WarningCard(
                    icon: 'empty',
                    message: AppLocalizations.of(context)!.youAreNotPartOfAnyGroup,
                  );
                }
              }

              if(state is GroupsLoading) {
                return const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if(state is GroupsError) {
                return WarningCard(
                  icon: 'error',
                  message: AppLocalizations.of(context)!.anErrorOccurred,
                );
              }
              if(state is GroupsDone) {
                if (state.groups?.isEmpty ?? true) {
                  return WarningCard(
                    icon: 'empty',
                    message: AppLocalizations.of(context)!.noResults,
                  );
                } else {
                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.groups?.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            context.pushNamed(
                              'group',
                              pathParameters: {
                                'groupId': state.groups?[index]?.id.toString() ?? '',
                              },
                            );
                          },
                          leading: state.groups?[index]?.picturePath != null ? CachedImageWidget(
                            borderRadius: BorderRadius.circular(16),
                            imageUrl: state.groups?[index]?.picturePath ?? '',
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
                          title: Text(
                              state.groups?[index]?.name ?? '',
                              style: Theme.of(context).textTheme.titleMedium
                          ),
                          subtitle: Text(
                            state.groups?[index]?.description ?? '',
                            maxLines: 1,
                          ),
                        );
                      },
                    )
                  );
                }
              }
              return const SizedBox();
            },
          ),
        ),
      ]
    );
  }
}