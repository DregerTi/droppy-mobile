abstract class ContentEvent {
  const ContentEvent();
}

class SearchContent extends ContentEvent {
  final Map<String, dynamic>? params;

  const SearchContent(this.params);
}