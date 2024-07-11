abstract class LikesEvent {
  const LikesEvent();
}

class PostLike extends LikesEvent {
  final Map<String, dynamic> params;

  const PostLike(this.params);
}

class DeleteLike extends LikesEvent {
  final Map<String, dynamic> params;

  const DeleteLike(this.params);
}