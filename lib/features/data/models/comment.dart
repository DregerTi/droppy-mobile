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
    DateTime ? createdAt,
  }) : super(
    id: id,
    content: content,
    user: user,
    drop: drop,
    commentResponses: commentResponses,
    createdAt: createdAt,
  );
  
  factory CommentModel.fromJson(Map<String, dynamic >map) {
    return CommentModel(
      id: map['ID'] ?? 0,
      content: map['Content'] ?? "",
      user: map['CreatedBy'] != null ? UserModel.fromJson(map['CreatedBy']) : null,
      drop: map['Drop'] != null ? DropModel.fromJson(map['Drop']) : null,
      commentResponses: (map['Responses'] != null
        && map['Responses'].length > 0 ?
        (map['Responses'] as List<dynamic>)
            .map((commentResponse) => CommentResponseModel.fromJson(commentResponse))
            .toList()
            : []
        ),
      createdAt: DateTime.parse(map['CreatedAt'].toString()),
    );
  }

  factory CommentModel.fromEntity(CommentModel entity) {
    return CommentModel(
      id: entity.id,
      content: entity.content,
      user: entity.user,
      drop: entity.drop,
      commentResponses: entity.commentResponses,
      createdAt: entity.createdAt,
    );
  }
}