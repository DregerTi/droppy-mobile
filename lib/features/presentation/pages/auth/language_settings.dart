import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/l10n.dart';
import '../../../domain/entities/select_item.dart';
import '../../bloc/lang/lang_bloc.dart';
import '../../bloc/lang/lang_event.dart';
import '../../../data/models/user.dart';
import '../../widgets/molecules/form_section.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageSettings extends StatefulWidget {
  final UserModel user;

  const LanguageSettings({
    Key? key,
    required this.user
  }) : super(key: key);

  @override
  State<LanguageSettings> createState() => _LanguageSettingsState();
}

class _LanguageSettingsState extends State<LanguageSettings> {
  @override
  Widget build(BuildContext context) {

    List<SelectItemEntity> selectItems = L10n.all.map((entry) {
      var label = entry.toString();
      switch (entry.toString()) {
        case "fr":
          label = AppLocalizations.of(context)!.fr;
        case "en":
          label = AppLocalizations.of(context)!.en;
        case "es":
          label = AppLocalizations.of(context)!.es;
        case "de":
          label = AppLocalizations.of(context)!.de;
        case "it":
          label = AppLocalizations.of(context)!.it;
        case "pt":
          label = AppLocalizations.of(context)!.pt;
        case "ar":
          label = AppLocalizations.of(context)!.ar;
        case "hi":
          label = AppLocalizations.of(context)!.hi;
        case "zh":
          label = AppLocalizations.of(context)!.zh;
      }

      return SelectItemEntity(
          value: L10n.all.indexOf(entry),
          label: label,
      );
    }).toList();
    var selectedItem;
    var lang = context.read<LangBloc>().state.lang;
    if (lang != null) {
      selectedItem = selectItems.firstWhere((element) => L10n.all[element.value].languageCode == lang, orElse: () => const SelectItemEntity(value: 0, label: ''));
    }

    return Scaffold(
      body: FormSection(
        title: AppLocalizations.of(context)!.preferredLanguages,
        sectionTitle: AppLocalizations.of(context)!.preferredLanguages,
        description: AppLocalizations.of(context)!.chooseYourLanguage,
        selectItems: selectItems,
        selectedItem: selectedItem,
        setSelectedItem: (item) {
          setState(() {
            selectedItem = item;
          });
          context.read<LangBloc>().add(UpdateLang(L10n.all[item.value].languageCode));
        },
        leadingOnPressed: () {
          context.pop();
        },
      ),
    );
  }
}
