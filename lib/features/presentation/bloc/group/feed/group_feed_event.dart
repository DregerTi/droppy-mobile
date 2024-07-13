abstract class GroupFeedEvent {
  const GroupFeedEvent();
}

class GetGroupFeed extends GroupFeedEvent {
  final Map<String, dynamic>? params;

  const GetGroupFeed(this.params);
}
