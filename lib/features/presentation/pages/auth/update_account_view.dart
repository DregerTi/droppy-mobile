import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/color.dart';
import '../../../../config/theme/widgets/button.dart';
import '../../../../config/theme/widgets/text.dart';
import '../../../data/models/user.dart';
import '../../../domain/entities/media_picker_item.dart';
import '../../bloc/user/user_bloc.dart';
import '../../bloc/user/user_event.dart';
import '../../bloc/user/user_state.dart';
import '../../widgets/atoms/snack_bar.dart';
import '../../widgets/molecules/app_bar_widget.dart';
import '../../widgets/molecules/media_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpdateAccountView extends StatefulWidget {
  final UserModel user;

  const UpdateAccountView({
    super.key,
    required this.user
  });

  @override
  State<UpdateAccountView> createState() => _UpdateAccountViewState();
}

class _UpdateAccountViewState extends State<UpdateAccountView> {
  final formKey = GlobalKey<FormState>();
  final descriptionFormKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String activeElement = 'main';
  List<MediaPickerItemEntity> selectedMedias = [];
  bool isPrivate = true;

  @override
  initState() {
    usernameController.text = widget.user.username!;
    descriptionController.text = widget.user.bio!;
    isPrivate = widget.user.isPrivate!;
    super.initState();
  }

  String? usernameError(String? value) {
    if (value!.length < 4 || value.length > 26) {
      return 'Entre 4 et 26 caractères';
    }
    return null;
  }

  String? descriptionError(String? value) {
    if ((value!.length < 5 || value.length > 60) && value.isNotEmpty) {
      return 'Entre 5 et 60 caractères ou vide';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - kBottomNavigationBarHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: activeElement == 'main',
                    child: AppBarWidget(
                      leadingIcon: const Icon(Icons.arrow_back),
                      title: AppLocalizations.of(context)!.myAccount,
                      actionWidget: BlocConsumer<UsersBloc, UsersState>(
                        listener: (context, state) {
                          if(state is PatchUserError) {
                            snackBarWidget(
                              message: AppLocalizations.of(context)!.loadingError,
                              context: context,
                              type: 'error',
                            );
                          }
                          if(state is PatchUserDone) {
                            snackBarWidget(
                              message: 'Group mis à jour',
                              context: context,
                            );
                            context.pop(true);
                          }
                        },
                        builder: (context, state) {
                          return IconButton(
                            icon: (state is PatchUserLoading)
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

                                Map<String, dynamic> data = {
                                  'username': usernameController.text,
                                  'bio': descriptionController.text ?? '',
                                  'isPrivate': isPrivate,
                                };

                                if (selectedMedias.isNotEmpty) {
                                  final mainMedia = await MultipartFile.fromFile((await selectedMedias[0].assetEntity!.file)!.path);
                                  data['picture'] = mainMedia;
                                }

                                print({
                                  'id': widget.user.id,
                                  'user': data,
                                });

                                context.read<UsersBloc>().add(PatchUser({
                                  'id': widget.user.id,
                                  'user': data,
                                }));
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  if (activeElement == 'main') const SizedBox(height: 20),
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
                                initialMediaEntities: widget.user.avatar != null ? [widget.user.avatar!] : null,
                                selectedMedias: [],
                              ),
                            ),
                            if (activeElement == 'main') const SizedBox(width: 10),
                            Flexible(
                              child: Form(
                                key: formKey,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      controller: usernameController,
                                      validator: usernameError,
                                      decoration: InputDecoration(
                                        hintText: AppLocalizations.of(context)!.lastName,
                                        helperText: '',
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                  ],
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
                                isPrivate = !isPrivate;
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width - 48,
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: isPrivate ? surfaceColor : primaryColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    isPrivate ? Icons.lock_open_rounded : Icons.lock_rounded,
                                    color: isPrivate ? onSurfaceColor : textColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    isPrivate ? 'Compte privé' : 'Compte publique',
                                    style: textTheme.labelMedium?.copyWith(
                                      color: isPrivate ? onSurfaceColor : textColor,
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
                              validator: descriptionError,
                              decoration: const InputDecoration(
                                hintText: 'Description...',
                                helperText: '',
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ),
                ],
              ),
            )
          ),
        ],
      ),
    );
  }
}