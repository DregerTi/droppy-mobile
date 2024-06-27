abstract class ReportsEvent {
  const ReportsEvent();
}

class PostReport extends ReportsEvent {
  final Map<String, dynamic> params;

  const PostReport(this.params);
}