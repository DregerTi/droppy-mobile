

import '../../domain/entities/report.dart';

class ReportModel extends ReportEntity {
  const ReportModel({
    String ? message,
    String ? commentIri,
    String ? dropIri,
    String ? commentReponseIri,
    String ? description,
  }) : super(
    message: message,
    commentIri: commentIri,
    dropIri: dropIri,
    commentReponseIri: commentReponseIri,
    description: description
  );
  
  factory ReportModel.fromJson(Map<String, dynamic >map) {

    return ReportModel(
      message: map['message'] ?? "",
      commentIri: map['commentIri'] ?? "",
      dropIri: map['dropIri'] ?? "",
      commentReponseIri: map['commentReponseIri'] ?? "",
      description: map['description'] ?? "",
    );
  }

  factory ReportModel.fromEntity(ReportModel entity) {
    return ReportModel(
      message: entity.message,
      commentIri: entity.commentIri,
      dropIri: entity.dropIri,
      commentReponseIri: entity.commentReponseIri,
      description: entity.description,
    );
  }
}