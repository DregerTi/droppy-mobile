import 'package:droppy/features/data/models/report.dart';
import 'package:droppy/features/data/models/user.dart';
import 'package:droppy/features/data/models/comment.dart';
import 'package:droppy/features/data/models/content_type.dart';
import 'package:droppy/features/data/models/like.dart';
import '../../domain/entities/drop.dart';

class DropModel extends DropEntity {
  const DropModel({
    String ? iri,
    int ? id,
    String ? content,
    String ? description,
    String ? picturePath,
    bool ? isPinned,
    List<ReportModel> ? reports,
    ContentTypeModel ? contentType,
    UserModel ? user,
    List<CommentModel> ? comments,
    bool ? isCurrentUserLiking,
    int? totalComments,
    int? totalLikes
  }) : super(
    iri: iri,
    id: id,
    content: content,
    description: description,
    picturePath: picturePath,
    isPinned: isPinned,
    reports: reports,
    contentType: contentType,
    user: user,
    comments: comments,
    isCurrentUserLiking: isCurrentUserLiking,
    totalComments: totalComments,
    totalLikes: totalLikes
  );
  
  factory DropModel.fromJson(Map<String, dynamic >map) {
    return DropModel(
      iri: map['@id'] ?? "",
      id: map['ID'] ?? "",
      content: map['Content'] ?? "",
      description: map['Description'] ?? "",
      picturePath: map['PicturePath'] ?? "",
      isPinned: map['IsPinned'] ?? false,
      reports: (map['Reports'] != null
          && map['Reports'].length > 0 ?
        (map['Reports'] as List<dynamic>)
          .map((report) => ReportModel.fromJson(report))
          .toList()
        : []
      ),
      contentType: map['ContentType'] != null ? ContentTypeModel.fromJson(map['ContentType']) : null,
      user: map['CreatedBy'] != null ? UserModel.fromJson(map['CreatedBy']) : null,
      comments: (map['Comments'] != null
          && map['Comments'].length > 0 ?
        (map['Comments'] as List<dynamic>)
          .map((comment) => CommentModel.fromJson(comment))
          .toList()
        : []
      ),
      isCurrentUserLiking: map['IsCurrentUserLiking'] ?? false,
      totalComments: map['TotalComments'] ?? 0,
      totalLikes: map['TotalLikes'] ?? 0
    );
  }

  factory DropModel.fromEntity(DropModel entity) {
    return DropModel(
      iri: entity.iri,
      id: entity.id,
      content: entity.content,
      description: entity.description,
      picturePath: entity.picturePath,
      isPinned: entity.isPinned,
      reports: entity.reports,
      contentType: entity.contentType,
      user: entity.user,
      comments: entity.comments,
      isCurrentUserLiking: entity.isCurrentUserLiking,
      totalComments: entity.totalComments,
      totalLikes: entity.totalLikes
    );
  }
}