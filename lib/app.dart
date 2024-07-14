import 'dart:ui';
import 'l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/routes/routes.dart';
import 'config/theme/app_themes.dart';
import 'features/presentation/bloc/auth/auth_bloc.dart';
import 'features/presentation/bloc/lang/lang_bloc.dart';
import 'features/presentation/bloc/lang/lang_event.dart';
import 'features/presentation/bloc/lang/lang_state.dart';
import 'features/presentation/bloc/user/user_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'injection_container.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {

    Locale lang = const Locale('en');


    return MultiBlocProvider(
      providers: [
        BlocProvider<LangBloc>(
          create: (context) => sl()..add(InitLang(window.locale.languageCode)),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => sl(),
        ),
        BlocProvider<UsersBloc>(
          create: (context) => sl(),
        ),
        BlocProvider<FeedBloc>(
          create: (context) => sl(),
        ),
      ],
      child: Builder(
        builder: (BuildContext context) {
          return BlocListener<LangBloc, LangState>(
            listener: (context, state) {
              if(state is LangDone){
                setState(() {
                  lang = Locale(state.lang ?? 'fr');
                });
              }
            },
            child: MaterialApp.router(
              title: 'Droppy',
              debugShowCheckedModeBanner: false,
              theme: theme(),
              routerConfig: AppRoutes.router,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: L10n.all,
              locale: Locale(BlocProvider.of<LangBloc>(context).state.lang ?? lang.languageCode),
            ),
          );
        },
      ),
    );
  }
}
