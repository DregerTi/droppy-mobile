import '../../domain/entities/report.dart';

class ReportModel extends ReportEntity {
  const ReportModel({
    String ? message,
    String ? commentId,
    String ? dropId,
    String ? commentReponseId,
    String ? description,
  }) : super(
    message: message,
    commentId: commentId,
    dropId: dropId,
    commentReponseId: commentReponseId,
    description: description
  );
  
  factory ReportModel.fromJson(Map<String, dynamic >map) {

    return ReportModel(
      message: map['message'] ?? "",
      commentId: map['commentId'] ?? "",
      dropId: map['dropId'] ?? "",
      commentReponseId: map['commentReponseId'] ?? "",
      description: map['description'] ?? "",
    );
  }

  factory ReportModel.fromEntity(ReportModel entity) {
    return ReportModel(
      message: entity.message,
      commentId: entity.commentId,
      dropId: entity.dropId,
      commentReponseId: entity.commentReponseId,
      description: entity.description,
    );
  }
}