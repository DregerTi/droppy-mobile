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
    LikeModel ? currentUserLike,
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
    currentUserLike: currentUserLike,
  );
  
  factory DropModel.fromJson(Map<String, dynamic >map) {
    return DropModel(
      iri: map['@id'] ?? "",
      id: map['id'] ?? "",
      content: map['content'] ?? "",
      description: map['description'] ?? "",
      picturePath: map['picturePath'] ?? "",
      isPinned: map['isPinned'] ?? false,
      reports: (map['reports'] != null
          && map['reports'].length > 0 ?
        (map['reports'] as List<dynamic>)
          .map((report) => ReportModel.fromJson(report))
          .toList()
        : []
      ),
      contentType: map['contentType'] != null ? ContentTypeModel.fromJson(map['contentType']) : null,
      user: map['user'] != null ? UserModel.fromJson(map['user']) : null,
      comments: (map['comments'] != null
          && map['comments'].length > 0 ?
        (map['comments'] as List<dynamic>)
          .map((comment) => CommentModel.fromJson(comment))
          .toList()
        : []
      ),
      currentUserLike: map['currentUserLike'] != null ? LikeModel.fromJson(map['currentUserLike']) : null,
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
      currentUserLike: entity.currentUserLike
    );
  }
}