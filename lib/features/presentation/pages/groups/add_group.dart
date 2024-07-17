import 'package:dio/dio.dart';
import 'package:droppy/config/theme/widgets/text.dart';
import 'package:droppy/features/data/models/user.dart';
import 'package:droppy/features/presentation/bloc/follow/get/follow_get_bloc.dart';
import 'package:droppy/features/presentation/widgets/organisms/search_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../../config/theme/color.dart';
import '../../../../config/theme/widgets/button.dart';
import '../../../../injection_container.dart';
import '../../../domain/entities/media_picker_item.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/follow/get/follow_get_event.dart';
import '../../bloc/group/goup_bloc.dart';
import '../../bloc/group/group_event.dart';
import '../../bloc/group/group_state.dart';
import '../../bloc/user/user_bloc.dart';
import '../../bloc/user/user_event.dart';
import '../../widgets/atoms/cached_image_widget.dart';
import '../../widgets/atoms/snack_bar.dart';
import '../../widgets/molecules/app_bar_widget.dart';
import '../../widgets/molecules/media_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddGroupView extends StatefulWidget {

  const AddGroupView({
    super.key,
  });

  @override
  State<AddGroupView> createState() => _AddGroupViewState();
}

class _AddGroupViewState extends State<AddGroupView> {
  bool isPublic = true;
  final formKey = GlobalKey<FormState>();
  String activeElement = 'main';
  TextEditingController titleController = TextEditingController();
  List<MediaPickerItemEntity> selectedMedias = [];
  String? titleError;
  List<UserModel> selectedUsers = [];

  String? titleValidation(String? value) {
    if (value!.length < 2 || value.length > 22) {
      return AppLocalizations.of(context)!.between2And22Characters;
    }
    return null;
  }
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
    providers: [
      BlocProvider<FollowGetBloc>(
        create: (context) => sl()..add(GetUserFollowed({
          'id': int.parse(BlocProvider.of<AuthBloc>(context).state.auth!.id.toString())
        })),
      ),
    ],
    child: Scaffold(
        backgroundColor: backgroundColor,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Visibility(
                visible: activeElement == 'main' || activeElement == 'medias',
                child: Column(
                  children: [
                    Visibility(
                      visible: activeElement == 'main',
                      child: AppBarWidget(
                        title: AppLocalizations.of(context)!.createGroup,
                        leadingIcon: const Icon(Icons.arrow_back),
                        leadingOnPressed: () {
                          context.pop();
                        },
                        actionWidget: BlocConsumer<GroupsBloc, GroupsState>(
                          listener: (context, state) {
                            if(state is PostGroupError) {
                              snackBarWidget(
                                message: AppLocalizations.of(context)!.loadingError,
                                context: context,
                                type: 'error',
                              );
                            }
                            if(state is PostGroupDone) {
                              BlocProvider.of<UsersBloc>(context).add(GetMe({
                                'id': BlocProvider.of<AuthBloc>(context).state.auth?.id
                              }));
                              snackBarWidget(
                                message: AppLocalizations.of(context)!.groupCreatedSuccessfully,
                                context: context,
                              );
                              context.pop(true);
                            }
                          },
                          builder: (context, state) {
                            return IconButton(
                              icon: (state is PostGroupLoading)
                                ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: Center(
                                    child: CircularProgressIndicator()
                                  )
                                )
                                : const Icon(Icons.check_rounded),
                              style: iconButtonThemeData.style?.copyWith(
                                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                if(formKey.currentState!.validate()) {

                                  var data = {
                                    'name': titleController.text,
                                    'isPrivate': isPublic ? false : true,
                                    'members': selectedUsers.map((e) => e.id).toList(),
                                  };

                                  if (selectedMedias.isNotEmpty) {
                                    final mainMedia = await MultipartFile.fromFile((await selectedMedias[0].assetEntity!.file)!.path);
                                    data['picture'] = mainMedia;
                                  }

                                  context.read<GroupsBloc>().add(PostGroup(data));
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: activeElement == 'main' ? const EdgeInsets.only(top: 20, bottom: 0, left: 24, right: 24) : const EdgeInsets.all(0),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: activeElement == 'main' ? 56 : MediaQuery.of(context).size.width,
                                height: activeElement == 'main' ? 56 : MediaQuery.of(context).size.height,
                                child: MediaPickerWidget(
                                  lite: true,
                                  maxMedias: 1,
                                  activeElement: activeElement,
                                  setActiveElement: (value) {
                                    setState(() {
                                      activeElement = value;
                                    });
                                  },
                                  setSelectedMedias: (value) {
                                    setState(() {
                                      selectedMedias = value;
                                    });
                                  },
                                  selectedMedias: [],
                                ),
                              ),
                              if (activeElement == 'main') const SizedBox(width: 10),
                              if (activeElement == 'main') Flexible(
                                child: Form(
                                  key: formKey,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  child: TextFormField(
                                      controller: titleController,
                                      validator: titleValidation,
                                      textInputAction: TextInputAction.search,
                                      decoration: InputDecoration(
                                        hintText: AppLocalizations.of(context)!.name,
                                        helperText: '',
                                      )
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (activeElement == 'main') Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isPublic = !isPublic;
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width - 48,
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: isPublic ? surfaceColor : primaryColor,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      isPublic ? Icons.lock_open_rounded : Icons.lock_rounded,
                                      color: isPublic ? onSurfaceColor : textColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      isPublic ? AppLocalizations.of(context)!.publicGroup : AppLocalizations.of(context)!.privateGroup,
                                      style: textTheme.labelMedium?.copyWith(
                                        color: isPublic ? onSurfaceColor : textColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
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
                                              child: (selectedUsers[index].avatar != null) ? CachedImageWidget(
                                                imageUrl: selectedUsers[index].avatar!,
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
                                                  setState(() {
                                                    selectedUsers.removeAt(index);
                                                  });
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
                                              selectedUsers[index].username ?? '',
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
                    if (activeElement == 'main') Expanded(
                      child: SearchUsers(
                        showFollowing: true,
                        onTap: (user) {
                          setState(() {
                            if (selectedUsers.contains(user)) {
                              selectedUsers.remove(user);
                            } else {
                              selectedUsers.add(user);
                            }
                          });
                        },
                      )
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}