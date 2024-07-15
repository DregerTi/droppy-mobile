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
      id: map['ID'],
      content: map['Content'] ?? "",
      user: map['CreatedBy'] != null ? UserModel.fromJson(map['CreatedBy']) : null,
      comment: map['Comment'] != null ? CommentModel.fromJson(map['Comment']) : null,
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