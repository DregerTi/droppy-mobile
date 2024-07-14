import 'dart:async';

import 'package:droppy/features/presentation/bloc/user/user_state.dart';
import 'package:droppy/features/presentation/widgets/atoms/warning_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/color.dart';
import '../../../../config/theme/widgets/text.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/follow/get/follow_get_bloc.dart';
import '../../bloc/follow/get/follow_get_state.dart';
import '../../bloc/user/user_bloc.dart';
import '../../bloc/user/user_event.dart';
import '../atoms/cached_image_widget.dart';

class SearchUsers extends StatefulWidget {
  final Function? onTap;
  final bool showFollowing;

  const SearchUsers({
    super.key,
    this.onTap,
    this.showFollowing = false,
  });

  @override
  State<SearchUsers> createState() => _SearchUsersState();
}

class _SearchUsersState extends State<SearchUsers> {
  TextEditingController searchFieldController = TextEditingController();
  String? searchFieldValue;
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
    return Expanded(
      child: Column(
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
                      setState(() {
                        searchFieldValue = input;
                      });
                      if (debounce?.isActive ?? false) debounce?.cancel();
                      if (input.isNotEmpty) {
                        debounce = Timer(const Duration(milliseconds: 1000), () {
                          BlocProvider.of<UsersBloc>(context).add(GetUsersSearch({
                            'search': input,
                          }));
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: 'Recherche',
                      suffixIcon: Icon(Icons.search, color: onSurfaceColor, size: 20),
                    )
                  ),
                )
              ],
            ),
          ),
          if(searchFieldController.text.isEmpty && widget.showFollowing) Expanded(
            child: BlocConsumer<FollowGetBloc, FollowGetState>(
              builder: (context, state) {
                if (state is FollowedLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (state is FollowedDone && (state.users?.isNotEmpty ?? false)){
                  return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24, top: 14, bottom: 0),
                              child: Text(
                                  'Following',
                                  style: textTheme.titleMedium
                              )
                          ),
                          ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: (BlocProvider.of<FollowGetBloc>(context).state as FollowedDone).users?.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  if(widget.onTap != null) {
                                    widget.onTap!((BlocProvider.of<FollowGetBloc>(context).state as FollowedDone).users?[index]);
                                  } else {
                                    context.goNamed(
                                      'user-profile',
                                      pathParameters: {
                                        'userId': (BlocProvider.of<FollowGetBloc>(context).state as FollowedDone).users?[index]?.id.toString() ?? '',
                                      },
                                    );
                                  }
                                },
                                leading: (BlocProvider.of<FollowGetBloc>(context).state as FollowedDone).users?[index]?.avatar != null ? CachedImageWidget(
                                  borderRadius: BorderRadius.circular(16),
                                  imageUrl: (BlocProvider.of<FollowGetBloc>(context).state as FollowedDone).users?[index]?.avatar ?? '',
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
                                    (BlocProvider.of<FollowGetBloc>(context).state as FollowedDone).users?[index]?.username ?? '',
                                    style: Theme.of(context).textTheme.titleMedium
                                ),
                                subtitle: Text(
                                  (BlocProvider.of<FollowGetBloc>(context).state as FollowedDone).users?[index]?.bio ?? '',
                                ),
                              );
                            },
                          ),
                        ],
                      )
                  );
                }

                return const SizedBox();
              },
              listener: (context, state) {},
            ),
          ) else Expanded(
            child: BlocConsumer<UsersBloc, UsersState>(
              listener: (BuildContext context, UsersState state) {  },
              builder: (_,state) {
                if(state is UsersSearchLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if(state is UsersSearchError) {
                  return const WarningCard(
                    icon: 'error',
                    message: 'Une erreur est survenue',
                  );
                }
                if(state is UsersSearchDone) {
                  if (state.users?.isEmpty ?? true) {
                    return const WarningCard(
                      icon: 'empty',
                      message: 'Aucun résultat',
                    );
                  } else {
                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.users?.length,
                        itemBuilder: (context, index) {
                          return (BlocProvider.of<AuthBloc>(context).state.auth?.id != state.users?[index]?.id) ? ListTile(
                            onTap: () {
                              if(widget.onTap != null) {
                                widget.onTap!(state.users?[index]);
                              } else {
                                context.goNamed(
                                  'user-profile',
                                  pathParameters: {
                                    'userId': state.users?[index]?.id.toString() ?? '',
                                  },
                                );
                              }
                            },
                            leading: state.users?[index]?.avatar != null ? CachedImageWidget(
                              borderRadius: BorderRadius.circular(16),
                              imageUrl: BlocProvider.of<UsersBloc>(context).state.users?[index]?.avatar ?? '',
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
                                state.users?[index]?.username ?? '',
                                style: Theme.of(context).textTheme.titleMedium
                            ),
                            subtitle: Text(
                              state.users?[index]?.bio ?? '',
                            ),
                          ) : const SizedBox();
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
      ),
    );
  }
}