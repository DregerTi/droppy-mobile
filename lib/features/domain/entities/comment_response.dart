import 'package:equatable/equatable.dart';
import '../../data/models/comment.dart';
import '../../data/models/user.dart';

class CommentResponseEntity extends Equatable {
  final int? id;
  final String? content;
  final UserModel? user;
  final CommentModel? comment;

  const CommentResponseEntity({
    this.id,
    this.content,
    this.user,
    this.comment,
  });

  @override
  List<Object?> get props {
    return [
      id,
      content,
      user,
      comment,
    ];
  }
}
