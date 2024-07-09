import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../config/theme/color.dart';
import '../../../data/models/user.dart';
import '../../../domain/entities/media_picker_item.dart';
import '../../bloc/user/user_bloc.dart';
import '../../bloc/user/user_event.dart';
import '../../bloc/user/user_state.dart';
import '../../widgets/atoms/snack_bar.dart';
import '../../widgets/molecules/action_bar.dart';
import '../../widgets/molecules/app_bar_widget.dart';
import '../../widgets/molecules/media_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpdateAccountView extends StatefulWidget {
  final UserModel user;

  const UpdateAccountView({
    Key? key,
    required this.user
  }) : super(key: key);

  @override
  State<UpdateAccountView> createState() => _UpdateAccountViewState();
}

class _UpdateAccountViewState extends State<UpdateAccountView> {
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  String activeElement = 'main';

  List<MediaPickerItemEntity> selectedMedias = [];

  @override
  initState() {
    usernameController.text = widget.user.username!;
    super.initState();
  }

  String? fistnameError(String? value) {
    if (value!.length < 2 || value.length > 50) {
      return 'Le prénom doit être compris entre 2 et 50 caractères';
    }
    return null;
  }

  String? lastnameError(String? value) {
    if (value!.length < 2 || value.length > 50) {
      return 'Le nom doit être compris entre 2 et 50 caractères';
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
                      ),
                    ),
                    Visibility(
                        visible: activeElement == 'main',
                        child: const SizedBox(height: 32)
                    ),
                    MediaPickerWidget(
                      setSelectedMedias: (value) {
                        setState(() {
                          selectedMedias = value;
                        });
                      },
                      maxMedias: 1,
                      activeElement: activeElement,
                      selectedMedias: selectedMedias,
                      initialMediaEntities: widget.user.avatar != null ? [widget.user.avatar!] : null,
                      setActiveElement: (value) {
                        setState(() {
                          activeElement = value;
                        });
                      },
                    ),
                    if (activeElement == 'main') const SizedBox(height: 20),
                    if (activeElement == 'main') Padding(
                        padding: const EdgeInsets.only(top: 12, left: 20, right: 20),
                        child: Form(
                          key: formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: usernameController,
                                validator: fistnameError,
                                decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)!.lastName,
                                  helperText: '',
                                ),
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),
                        )
                    ),
                  ],
                ),
              )
          ),
          if (activeElement == 'main')  Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: textColor.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 1,
                  ),
                ],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(26),
                  topRight: Radius.circular(26),
                ),
              ),
              child: BlocConsumer<UsersBloc, UsersState>(
                builder: (context, state) {
                  return ActionBar(
                      leadingText: (state is PatchUserLoading) ? null : AppLocalizations.of(context)!.save,
                      leadingWidget: (state is PatchUserLoading) ? Image.asset('lib/assets/images/loading.gif', width: 30) : null,
                      leadingOnPressed: () async {
                        if(formKey.currentState!.validate()){

                          var data = {
                            "patchUser": {
                              'id': widget.user.id,
                              "user" : {
                                'username': usernameController.text,
                              }
                            }
                          };

                          MultipartFile? updatePicture;
                          if(selectedMedias != [] && selectedMedias.isNotEmpty){
                            updatePicture = await MultipartFile.fromFile((await selectedMedias[0].assetEntity!.file)!.path);
                            data['updatePicture'] = {
                              'id': widget.user.id,
                              'user': {
                                'updatePicture': updatePicture
                              }
                            };
                          }

                          context.read<UsersBloc>().add(
                              PatchUser(data)
                          );
                        }
                      }
                  );
                },
                listener: (BuildContext context, UsersState state) {
                  if(state is PatchUserDone) {
                    snackBarWidget(
                      message: 'Votre compte a été mis à jour',
                      context: context,
                    );
                    context.goNamed('account');
                  }
                  if(state is PatchUserError) {
                    snackBarWidget(
                      message: AppLocalizations.of(context)!.accountUpdateError,
                      context: context,
                      type: 'error',
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}