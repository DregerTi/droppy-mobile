import 'package:droppy/features/data/models/comment_response.dart';
import 'package:droppy/features/data/models/user.dart';
import 'package:droppy/features/data/models/drop.dart';
import '../../domain/entities/comment.dart';


class CommentModel extends CommentEntity {
  const CommentModel({
    int ? id,
    String ? content,
    UserModel ? user,
    DropModel ? drop,
    List<CommentResponseModel> ? commentResponses,
  }) : super(
    id: id,
    content: content,
    user: user,
    drop: drop,
    commentResponses: commentResponses,
  );
  
  factory CommentModel.fromJson(Map<String, dynamic >map) {
    return CommentModel(
      id: map['id'] ?? "",
      content: map['content'] ?? "",
      user: map['createdBy'] != null ? UserModel.fromJson(map['createdBy']) : null,
      drop: map['drop'] != null ? DropModel.fromJson(map['drop']) : null,
      commentResponses: (map['commentResponses'] != null ? List<CommentResponseModel>.from(map['commentResponses'].map((commentResponse) => CommentResponseModel.fromJson(commentResponse))) : []),
    );
  }

  factory CommentModel.fromEntity(CommentModel entity) {
    return CommentModel(
      id: entity.id,
      content: entity.content,
      user: entity.user,
      drop: entity.drop,
      commentResponses: entity.commentResponses,
    );
  }
}