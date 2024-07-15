import 'package:equatable/equatable.dart';
import '../../data/models/drop.dart';
import '../../data/models/user.dart';
import '../../data/models/comment_response.dart';

class CommentEntity extends Equatable {
  final int ? id;
  final String ? content;
  final UserModel ? user;
  final DropModel ? drop;
  final List<CommentResponseModel> ? commentResponses;
  final DateTime ? createdAt;

  const CommentEntity({
    this.id,
    this.content,
    this.user,
    this.drop,
    this.commentResponses,
    this.createdAt,
  });

  @override
  List<Object?> get props {
    return [
      id,
      content,
      user,
      drop,
      commentResponses,
      createdAt,
    ];
  }
}