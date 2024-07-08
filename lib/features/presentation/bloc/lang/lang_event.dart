abstract class LangEvent {
  const LangEvent();
}

class InitLang extends LangEvent {
  final String systemLang;

  const InitLang(this.systemLang);
}

class UpdateLang extends LangEvent {
  final String lang;

  const UpdateLang(this.lang);
}