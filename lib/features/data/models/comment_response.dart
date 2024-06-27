import 'package:droppy/features/data/models/comment.dart';
import 'package:droppy/features/data/models/user.dart';
import '../../domain/entities/comment_response.dart';


class CommentResponseModel extends CommentResponseEntity {
  const CommentResponseModel({
    int ? id,
    String ? content,
    UserModel ? user,
    CommentModel ? comment,
  }) : super(
    id: id,
    content: content,
    user: user,
    comment: comment,
  );
  
  factory CommentResponseModel.fromJson(Map<String, dynamic >map) {
    return CommentResponseModel(
      id: map['id'] ?? "",
      content: map['content'] ?? "",
      user: map['createdBy'] != null ? UserModel.fromJson(map['createdBy']) : null,
      comment: map['comment'] != null ? CommentModel.fromJson(map['comment']) : null,
    );
  }

  factory CommentResponseModel.fromEntity(CommentResponseModel entity) {
    return CommentResponseModel(
      id: entity.id,
      content: entity.content,
      user: entity.user,
      comment: entity.comment,
    );
  }
}