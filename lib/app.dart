import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/routes/routes.dart';
import 'config/theme/app_themes.dart';
import 'features/presentation/bloc/auth/auth_bloc.dart';
import 'features/presentation/bloc/user/user_bloc.dart';
import 'injection_container.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => sl(),
        ),
        BlocProvider<UsersBloc>(
          create: (context) => sl(),
        ),
      ],
      child: Builder(
        builder: (BuildContext context) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: theme(),
            routerConfig: AppRoutes.router,
          );
        },
      ),
    );
  }
}
