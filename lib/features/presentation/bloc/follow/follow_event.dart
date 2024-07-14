abstract class FollowsEvent {
  const FollowsEvent();
}

class PostFollow extends FollowsEvent {
  final Map<String, dynamic> params;

  const PostFollow(this.params);
}

class DeleteFollow extends FollowsEvent {
  final Map<String, dynamic> params;

  const DeleteFollow(this.params);
}

class AcceptFollow extends FollowsEvent {
  final Map<String, dynamic> params;

  const AcceptFollow(this.params);
}

class RefuseFollow extends FollowsEvent {
  final Map<String, dynamic> params;

  const RefuseFollow(this.params);
}