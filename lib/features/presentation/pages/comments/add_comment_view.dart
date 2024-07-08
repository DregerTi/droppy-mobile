import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../config/theme/color.dart';
import '../../../../../injection_container.dart';
import '../../../../config/theme/widgets/text.dart';
import '../../bloc/comment/remote/comment_bloc.dart';
import '../../bloc/comment/remote/comment_event.dart';
import '../../bloc/comment/remote/comment_state.dart';
import '../../widgets/atoms/snack_bar.dart';
import '../../widgets/molecules/action_bar.dart';
import '../../widgets/molecules/app_bar_widget.dart';

class AddCommentView extends StatefulWidget {
  final String toiletId;

  const AddCommentView({
    Key? key,
    required this.toiletId,
  }) : super(key: key);

  @override
  State<AddCommentView> createState() => _AddCommentViewState();
}

class _AddCommentViewState extends State<AddCommentView> {
  final formKey = GlobalKey<FormState>();
  TextEditingController commentMessage = TextEditingController();
  String commentError = '';

  String? commentMessageError(String? value) {
    if ((value!.length < 3 || value.length > 250) && value.isNotEmpty) {
      return 'Le commentaire doit être compris entre 3 et 250 caractères ou vide';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<CommentsBloc>(
              create: (context) => sl(),
            ),
          ],
          child: Scaffold(
            body: Stack(
              children: [
                SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - kBottomNavigationBarHeight,
                    child: Column(
                      children: [
                        const AppBarWidget(
                          leadingIcon: Icon(Icons.arrow_back),
                          title: 'Ajouter un commentaire',
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                commentError,
                                style: textTheme.bodySmall!.copyWith(
                                  color: Colors.red,
                                ),
                              ),
                              Form(
                                key: formKey,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                child: TextFormField(
                                  controller: commentMessage,
                                  maxLines: 8,
                                  validator: commentMessageError,
                                  decoration: const InputDecoration(
                                    hintText: 'Ajouter un commentaire...',
                                    helperText: '',
                                  ),
                                ),
                              )
                            ]
                          ),
                        ),
                      ],
                    ),
                  ),
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
                    child: BlocConsumer<CommentsBloc, CommentsState>(
                      listener: (context, state) {
                        if(state is PostCommentError) {
                          snackBarWidget(
                            message: 'Erreur lors de l\'ajout du commentaire',
                            context: context,
                            type: 'error',
                          );
                        }
                        if(state is PostCommentDone) {
                          snackBarWidget(
                            message: 'Commentaire ajouté avec succès!',
                            context: context,
                          );
                          context.pop(true);
                        }
                      },
                      builder: (context, state) {
                        return ActionBar(
                          leadingText: (state is PostCommentLoading) ? null : 'Enregistrer',
                          leadingWidget: (state is PostCommentLoading) ? Image.asset('lib/assets/images/loading.gif', width: 30) : null,
                          leadingOnPressed: () {
                            if(state is! PostCommentLoading && formKey.currentState!.validate()) {
                              BlocProvider.of<CommentsBloc>(context).add(
                                PostComment({
                                  'drop': '/drops/${widget.toiletId}',
                                  'content': commentMessage.text != '' ? commentMessage.text : null,
                                })
                              );
                            }
                          }
                        );
                      },
                    ),
                  ),
                ),
              ],
            )
          ),
        )
      ),
    );
  }
}