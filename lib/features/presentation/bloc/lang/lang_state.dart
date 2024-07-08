import 'package:equatable/equatable.dart';

abstract class LangState extends Equatable {
  final String? lang;

  const LangState({this.lang});

  @override
  List<Object?> get props => [lang];
}

class LangInit extends LangState {
  const LangInit();
}

class LangUpdate extends LangState {
  const LangUpdate();
}

class LangDone extends LangState {
  const LangDone(String lang) : super(lang: lang);
}