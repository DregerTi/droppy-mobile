import 'package:equatable/equatable.dart';

class ReportEntity extends Equatable {
  final String ? message;
  final String ? commentId;
  final String ? dropId;
  final String ? commentReponseId;
  final String ? description;

  const ReportEntity({
    this.message,
    this.commentId,
    this.dropId,
    this.commentReponseId,
    this.description
  });

  @override
  List<Object?> get props {
    return [
      message,
      commentId,
      dropId,
      commentReponseId,
      description
    ];
  }
}