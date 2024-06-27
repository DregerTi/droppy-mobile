import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../config/theme/color.dart';
import '../../../data/models/user.dart';
import '../../../domain/entities/media_picker_item.dart';
import '../../bloc/user/user_bloc.dart';
import '../../bloc/user/user_event.dart';
import '../../bloc/user/user_state.dart';
import '../../widgets/molecules/action_bar.dart';
import '../../widgets/molecules/app_bar_widget.dart';
import '../../widgets/molecules/media_picker.dart';

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
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  String activeElement = 'main';

  @override
  initState() {
    firstnameController.text = widget.user.firstname!;
    lastnameController.text = widget.user.lastname!;
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
                    const AppBarWidget(
                      leadingIcon: Icon(Icons.arrow_back),
                      title: 'Mon compte',
                    ),
                    const SizedBox(height: 32),
                    MediaPickerWidget(
                      setSelectedMedias: (value) {
                        /*setState(() {
                          selectedMedias = value;
                        });*/
                      },
                      maxMedias: 1,
                      activeElement: activeElement,
                      selectedMedias: [
                        MediaPickerItemEntity(
                          widget: Image.network(widget.user.avatar! ?? ''),
                        )
                      ],
                      setActiveElement: (value) {
                        setState(() {
                          activeElement = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(top: 12, left: 30, right: 30),
                      child: Form(
                        key: formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: firstnameController,
                              validator: fistnameError,
                              decoration: const InputDecoration(
                                hintText: 'Nom',
                                helperText: '',
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: lastnameController,
                              validator: lastnameError,
                              decoration: const InputDecoration(
                                hintText: 'Prénom',
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
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: const BoxDecoration(
                color: backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 10,
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(26),
                  topRight: Radius.circular(26),
                ),
              ),
              child: BlocConsumer<UsersBloc, UsersState>(
                builder: (context, state) {
                  if(state is PatchUserDone) {
                    context.goNamed('my-account');
                  }
                  return ActionBar(
                    leadingText: (state is PatchUserLoading) ? null : 'Enregistrer',
                    leadingWidget: (state is PatchUserLoading) ? Image.asset('lib/assets/images/loading.gif', width: 30) : null,
                    leadingOnPressed: () {
                      if(formKey.currentState!.validate()){
                        context.read<UsersBloc>().add(
                          PatchUser(
                            {
                              'id': widget.user.id,
                              "user" : {
                                'firstname': firstnameController.text,
                                'lastname': lastnameController.text,
                              }
                            }
                          )
                        );
                      }
                    }
                  );
                },
                listener: (BuildContext context, UsersState state) {
                  if(state is PatchUserDone) {
                    context.goNamed('my-account');
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


void _signOut(BuildContext context) {
  context.go('/');
}