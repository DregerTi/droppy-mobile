import 'package:flutter/cupertino.dart';
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
import '../../widgets/molecules/app_bar_widget.dart';

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
                      'ou',
                      style: textTheme.headlineMedium?.copyWith(
                        color: surfaceColor,
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
                              print(state.auth!);
                              print('OAuthDone');
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
    onPressed: () => _goToSignUp(context),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Pas encore de compte ?',
          style: textTheme.bodyMedium,
        ),
        const SizedBox(width: 8),
        Text(
          'Inscris-toi !',
          style: textTheme.titleMedium,
        ),
      ],
    ),
  );
}

void _goToSignUp(BuildContext context) {
  context.goNamed('sign-up');
}