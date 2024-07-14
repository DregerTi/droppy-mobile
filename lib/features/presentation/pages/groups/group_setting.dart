import 'package:dio/dio.dart';
import 'package:droppy/config/theme/widgets/text.dart';
import 'package:droppy/features/data/models/user.dart';
import 'package:droppy/features/presentation/widgets/atoms/warning_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../config/theme/color.dart';
import '../../../../config/theme/widgets/button.dart';
import '../../../../injection_container.dart';
import '../../../domain/entities/media_picker_item.dart';
import '../../bloc/group/goup_bloc.dart';
import '../../bloc/group/group_event.dart';
import '../../bloc/group/group_state.dart';
import '../../widgets/atoms/snack_bar.dart';
import '../../widgets/molecules/app_bar_widget.dart';
import '../../widgets/molecules/media_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GroupSettingView extends StatefulWidget {
  final int groupId;

  const GroupSettingView({
    super.key,
    required this.groupId,
  });

  @override
  State<GroupSettingView> createState() => _GroupSettingViewState();
}

class _GroupSettingViewState extends State<GroupSettingView> {
  bool isPublic = true;
  final formKey = GlobalKey<FormState>();
  final descriptionFormKey = GlobalKey<FormState>();
  String activeElement = 'main';
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<MediaPickerItemEntity> selectedMedias = [];
  String? titleError;
  List<UserModel> selectedUsers = [];

  String? titleValidation(String? value) {
    if (value!.length < 2 || value.length > 22) {
      return 'Entre 2 et 22 caractères';
    }
    return null;
  }

  String? descriptionValidation(String? value) {
    if ((value!.length < 2 || value.length > 30) && value.isNotEmpty) {
      return 'Entre 2 et 30 caractères ou vide';
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
        BlocProvider<GroupsBloc>(
          create: (context) => sl()..add(GetGroup({
            'id': widget.groupId,
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
                        title: 'Réglages',
                        leadingIcon: const Icon(Icons.arrow_back),
                        leadingOnPressed: () {
                          context.pop();
                        },
                        actionWidget: BlocConsumer<GroupsBloc, GroupsState>(
                          listener: (context, state) {
                            if(state is PatchGroupError) {
                              snackBarWidget(
                                message: AppLocalizations.of(context)!.loadingError,
                                context: context,
                                type: 'error',
                              );
                            }
                            if(state is PatchGroupDone) {
                              snackBarWidget(
                                message: 'Group mis à jour',
                                context: context,
                              );
                              context.pop(true);
                            }
                          },
                          builder: (context, state) {
                            return IconButton(
                              icon: (state is PatchGroupLoading)
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
                                if(formKey.currentState!.validate() && descriptionFormKey.currentState!.validate()) {

                                  var data = {
                                    'name': titleController.text,
                                    'isPrivate': isPublic ? false : true,
                                    'description': descriptionController.text ?? '',
                                  };

                                  if (selectedMedias.isNotEmpty) {
                                    final mainMedia = await MultipartFile.fromFile((await selectedMedias[0].assetEntity!.file)!.path);
                                    data['picture'] = mainMedia;
                                  }

                                  context.read<GroupsBloc>().add(PatchGroup({
                                    'id': widget.groupId,
                                    'group': data,
                                  }));
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    BlocConsumer<GroupsBloc, GroupsState>(
                      listener: (context, state) {
                        setState(() {
                          if (state is GroupDone) {
                            titleController.text = state.group?.name ?? '';
                            isPublic = !state.group!.isPrivate!;
                            descriptionController.text = state.group?.description ?? '';
                          }
                        });
                      },
                      builder: (context, state) {

                        if(state is GroupError) {
                          return Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(child: WarningCard(
                                  icon: 'error',
                                  message: AppLocalizations.of(context)!.anErrorOccurredPleaseRetry,
                                  onTap: () {
                                    context.read<GroupsBloc>().add(GetGroup({
                                      'id': widget.groupId,
                                    }));
                                  },
                                )),
                              ],
                            ),
                          );
                        }

                        if(state is GroupDone) {
                          return Padding(
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
                                        initialMediaEntities: state.group?.picturePath != null ? [state.group!.picturePath!] : null,
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
                                            decoration: const InputDecoration(
                                              hintText: 'Nom',
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
                                            isPublic ? 'Groupe publique' : 'Groupe privé',
                                            style: textTheme.labelMedium?.copyWith(
                                              color: isPublic ? onSurfaceColor : textColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                if (activeElement == 'main') Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Form(
                                    key: descriptionFormKey,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    child: TextFormField(
                                      controller: descriptionController,
                                      maxLines: 8,
                                      validator: descriptionValidation,
                                      decoration: const InputDecoration(
                                        hintText: 'Description...',
                                        helperText: '',
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }

                        return const Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(child: CircularProgressIndicator()),
                            ],
                          ),
                        );

                      },
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