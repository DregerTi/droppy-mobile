abstract class CommentsEvent {
  const CommentsEvent();
}

class GetUserComments extends CommentsEvent {
  final Map<String, dynamic>? params;

  const GetUserComments(this.params);
}

class PostComment extends CommentsEvent {
  final Map<String, dynamic> params;

  const PostComment(this.params);
}