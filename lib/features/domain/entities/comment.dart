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

  const CommentEntity({
    this.id,
    this.content,
    this.user,
    this.drop,
    this.commentResponses,
  });

  @override
  List<Object?> get props {
    return [
      id,
      content,
      user,
      drop,
      commentResponses,
    ];
  }
}