import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../../config/theme/color.dart';
import '../../../../../injection_container.dart';
import '../../../../config/theme/widgets/text.dart';
import '../../bloc/oauth/oauth_bloc.dart';
import '../../bloc/oauth/oauth_event.dart';
import '../../bloc/oauth/oauth_state.dart';
import '../../widgets/forms/sign_up_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
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
              padding: const EdgeInsets.only(top:20, left: 20, right: 20),
              child: Column(
                children: [
                  const SignUpForm(),
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
                          listener: (context, state) {},
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
                        const SizedBox(width: 16),
                        IconButton(
                          padding: const EdgeInsets.all(12),
                          icon: SvgPicture.asset(
                            'lib/assets/images/apple.svg',
                            width: 34,
                            height: 34,
                          ),
                          onPressed: () {},
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
    onPressed: () => _goToSignIn(context),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Tu as déjà un compte ?',
          style: textTheme.bodyMedium,
        ),
        const SizedBox(width: 8),
        Text(
          'Connecte-toi',
          style: textTheme.titleMedium,
        ),
      ],
    ),
  );
}

void _goToSignIn(BuildContext context) {
  context.pushNamed('sign-in');
}