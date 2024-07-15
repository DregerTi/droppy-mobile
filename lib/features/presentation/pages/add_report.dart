import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../injection_container.dart';
import '../../../config/theme/widgets/button.dart';
import '../bloc/report/report_bloc.dart';
import '../bloc/report/report_event.dart';
import '../bloc/report/report_state.dart';
import '../widgets/atoms/snack_bar.dart';
import '../widgets/molecules/app_bar_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddReportView extends StatefulWidget {
  final String? dropId;
  final String? commentId;
  final String? commentResponseId;

  const AddReportView({
    Key? key,
    this.dropId,
    this.commentId,
    this.commentResponseId,
  }) : super(key: key);

  @override
  State<AddReportView> createState() => _AddReportViewState();
}

class _AddReportViewState extends State<AddReportView> {
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
                        AppBarWidget(
                          leadingIcon: const Icon(Icons.arrow_back),
                          title: 'Signalez le ${ widget.dropId != null ? 'drop' : ''}  ${widget.commentId != null ? 'commentaire' : ''} ${widget.commentResponseId != null ? 'réponse' : ''}',
                          actionWidget: BlocConsumer<ReportsBloc, ReportsState>(
                            listener: (context, state) {
                              if(state is PostReportError) {
                                snackBarWidget(
                                  message: AppLocalizations.of(context)!.loadingError,
                                  context: context,
                                  type: 'error',
                                );
                              }
                              if(state is PostReportDone) {
                                snackBarWidget(
                                  message: 'Merci pour ton signalement!',
                                  context: context,
                                );
                                context.pop(true);
                              }
                            },
                            builder: (context, state) {
                              return IconButton(
                                icon: (state is PostReportLoading)
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

                                    Map<String, dynamic> data = {
                                      'description': reportMessage.text,
                                    };

                                    if(widget.dropId != null) {
                                      data['dropId'] = int.parse(widget.dropId!);
                                    }

                                    if(widget.commentId != null) {
                                      data['commentId'] = int.parse(widget.commentId!);
                                    }

                                    if(widget.commentResponseId != null) {
                                      data['commentResponseId'] = int.parse(widget.commentResponseId!);
                                    }

                                    context.read<ReportsBloc>().add(PostReport(data));
                                  }
                                },
                              );
                            },
                          ),
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
              ],
            )
          ),
        )
      ),
    );
  }
}