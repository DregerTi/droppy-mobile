import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/user/user_bloc.dart';
import '../../bloc/user/user_event.dart';
import '../../bloc/user/user_state.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignUpForm> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();

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

  String? passwordError(String? value) {
    if (value!.length < 8) {
      return 'Le mot de passe doit contenir au moins 8 caractères';
    }
    return null;
  }

  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isNotEmpty && !regex.hasMatch(value)
      ? 'Enter a valid email address'
      : null;
  }

  @override
  Widget build(context) {

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          SnackBar(content: Text('Authentication failed: ${state.error}'));
        } else if (state is AuthDone) {
          context.pushNamed('account');
        }
      },
      builder: (_, state) {
        if (state is AuthLoading) {
          const Center(child: CircularProgressIndicator());
        }

        if (state is AuthUnauthenticated) {
          return SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: firstnameController,
                        validator: fistnameError,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.firstName,
                          helperText: '',
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: lastnameController,
                        validator: lastnameError,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.lastName,
                          helperText: '',
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: emailController,
                        validator: validateEmail,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.email,
                          helperText: '',
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: passwordController,
                        validator: passwordError,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.password,
                          helperText: '',
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: confirmPasswordController,
                        validator: (value) {
                          if (value != passwordController.text) {
                            return 'Les mots de passe ne correspondent pas';
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.confirmPassword,
                          helperText: '',
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: BlocConsumer<UsersBloc, UsersState>(
                          listener: (context, state) {

                          },
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: () => {
                                if(formKey.currentState!.validate()){
                                  context.read<UsersBloc>().add(
                                    PostUser(
                                      {
                                        'firstname': firstnameController.text,
                                        'lastname': lastnameController.text,
                                        'email': emailController.text,
                                        'password': passwordController.text,
                                      }
                                    )
                                  ),
                                }
                              },
                              child: (state is PostUserLoading) ? Image.asset('lib/assets/images/loading.gif', width: 30) : Text(AppLocalizations.of(context)!.signup),
                            );
                          },
                        )
                      ),
                    ],
                  ),
                ),
              ),
          );
        }

        return Text(state.toString());
      },
    );
  }
}