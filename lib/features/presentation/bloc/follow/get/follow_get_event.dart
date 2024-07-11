abstract class FollowGetEvent {
  const FollowGetEvent();
}

class GetUserFollowers extends FollowGetEvent {
  final Map<String, dynamic>? params;

  const GetUserFollowers(this.params);
}

class GetUserFollowed extends FollowGetEvent {
  final Map<String, dynamic>? params;

  const GetUserFollowed(this.params);
}