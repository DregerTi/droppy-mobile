abstract class CommentsEvent {
  const CommentsEvent();
}

class PostComment extends CommentsEvent {
  final Map<String, dynamic> params;

  const PostComment(this.params);
}

class PostCommentResponse extends CommentsEvent {
  final Map<String, dynamic> params;

  const PostCommentResponse(this.params);
}