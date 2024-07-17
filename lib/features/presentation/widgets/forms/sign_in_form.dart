import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          SnackBar(content: Text('Authentication failed: ${state.error}'));
        } else if (state is AuthDone) {
          context.pushNamed('home');
        }
      },
      builder: (_, state) {
        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.email,
                    helperText: '',
                  ),
                  controller: emailController,
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.password,
                    helperText: '',
                    errorText: (state is AuthError)
                        ? 'Identifiant ou mot de passe incorrect'
                        : null,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => {
                      context.read<AuthBloc>().add(
                        Authenticate({
                          'email': emailController.text,
                          'password': passwordController.text,
                        }),
                      ),
                    },
                    child: (state is AuthLoading) ? Image.asset('lib/assets/images/loading.gif', width: 30) : const Text('Connexion'),
                  )
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
