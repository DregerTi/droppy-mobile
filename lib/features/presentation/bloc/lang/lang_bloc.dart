import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'lang_event.dart';
import 'lang_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LangBloc extends Bloc<LangEvent, LangState> {

  LangBloc() : super(const LangInit()){
    on <InitLang> (onInitLang);
    on <UpdateLang> (onUpdateLang);
  }

  void onInitLang(InitLang event, Emitter<LangState> emit) async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? lang = prefs.getString('lang');

    lang ??= event.systemLang;

    await prefs.setString('lang', lang);

    if (!AppLocalizations.supportedLocales.contains(Locale(lang!))){
      lang = 'en';
    }

    emit(
        LangDone(lang)
    );
  }

  void onUpdateLang(UpdateLang event, Emitter<LangState> emit) async {
    emit(
        const LangUpdate()
    );

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? lang = event.lang;
    await prefs.setString('lang', lang);

    if (!AppLocalizations.supportedLocales.contains(Locale(lang))){
      lang = 'en';
    }

    emit(
        LangDone(lang)
    );
  }
}