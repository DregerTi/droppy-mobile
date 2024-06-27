import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../config/theme/color.dart';
import '../../../../../injection_container.dart';
import '../../bloc/report/report_bloc.dart';
import '../../bloc/report/report_event.dart';
import '../../bloc/report/report_state.dart';
import '../../widgets/atoms/snackBar.dart';
import '../../widgets/molecules/action_bar.dart';
import '../../widgets/molecules/app_bar_widget.dart';

class AddDropReportView extends StatefulWidget {
  final String dropId;

  const AddDropReportView({
    Key? key,
    required this.dropId,
  }) : super(key: key);

  @override
  State<AddDropReportView> createState() => _AddDropReportViewState();
}

class _AddDropReportViewState extends State<AddDropReportView> {
  final formKey = GlobalKey<FormState>();
  TextEditingController reportMessage = TextEditingController();

  String? reportMessageError(String? value) {
    if (value!.length < 3 || value.length > 250) {
      return 'La raison de ton signalement doit être compris entre 3 et 250 caractères';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider<ReportsBloc>(
          create: (context) => sl(),
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
                          title: 'Signalez le Drop',
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: formKey,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: TextFormField(
                              controller: reportMessage,
                              maxLines: 8,
                              validator: reportMessageError,
                              decoration: const InputDecoration(
                                hintText: 'Votre message...',
                                helperText: '',
                              ),
                            ),
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
                    child: BlocConsumer<ReportsBloc, ReportsState>(
                      listener: (context, state) {
                        if(state is PostReportError) {
                          snackBarWidget(
                            context: context,
                            message: 'Erreur lors de l\'envoi du signalement',
                          );
                        }
                        if(state is PostReportDone) {
                          snackBarWidget(
                            context: context,
                            message: 'Signalement soumis avec succès!',
                          );
                          context.pop();
                        }
                      },
                      builder: (context, state) {
                        return ActionBar(
                          leadingText: (state is PostReportLoading) ? null : 'Enregistrer',
                          leadingWidget: (state is PostReportLoading) ? Image.asset('lib/assets/images/loading.gif', width: 30) : null,
                          leadingOnPressed: () {
                            if(state is! PostReportLoading && formKey.currentState!.validate()) {
                              BlocProvider.of<ReportsBloc>(context).add(
                                PostReport({
                                  'drop': '/drops/${widget.dropId}',
                                  'message': reportMessage.text,
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