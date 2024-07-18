import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../../config/theme/color.dart';
import '../../../../../injection_container.dart';
import '../../../../config/theme/widgets/text.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/oauth/oauth_bloc.dart';
import '../../bloc/oauth/oauth_event.dart';
import '../../bloc/oauth/oauth_state.dart';
import '../../widgets/forms/sign_in_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignInView extends StatelessWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: _buildBody(context),
      bottomNavigationBar: _buildBottom(context),
    );
  }
}

Widget _buildBody(context) {
  return BlocProvider<OAuthBloc>(
    create: (context) => sl(),
    child: SafeArea(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
              child: Column(
                children: [
                  SvgPicture.asset(
                    'lib/assets/images/logo.svg',
                    height: 45,
                  ),
                  const SizedBox(height: 20),
                  const SignInForm(),
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.or,
                      style: textTheme.headlineSmall?.copyWith(
                        color: secondaryTextColor,
                      )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40, bottom: 0, left: 40, right: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BlocConsumer<OAuthBloc, OAuthState>(
                          listener: (context, state) {
                            if (state is OAuthDone) {
                              context.read<AuthBloc>().add(
                                OAuthAuthenticate(state.auth!),
                              );
                            }
                          },
                          builder: (context, state) {
                            return IconButton(
                              padding: const EdgeInsets.all(16),
                              icon: Image.asset(
                                'lib/assets/images/google.png',
                                width: 30,
                                height: 30,
                              ),
                              onPressed:() {
                                context.read<OAuthBloc>().add(
                                  const SignInWithGoogle(),
                                );
                              }
           );
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildBottom(context) {
  return TextButton(
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    ),
    onPressed: () => _goToSignUp(context),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.noAccount,
          style: textTheme.bodyMedium,
        ),
        const SizedBox(width: 8),
        Text(
          AppLocalizations.of(context)!.createOne,
          style: textTheme.titleMedium,
        ),
      ],
    ),
  );
}

void _goToSignUp(BuildContext context) {
  context.pushNamed('sign-up');
}