import 'package:droppy/features/data/models/user.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/content_type.dart';
import '../../data/models/report.dart';
import '../../data/models/comment.dart';


class DropEntity extends Equatable {
  final String ? iri;
  final int ? id;
  final String ? content;
  final String ? description;
  final String ? picturePath;
  final bool ? isPinned;
  final List<ReportModel> ? reports;
  final ContentTypeModel ? contentType;
  final UserModel ? user;
  final List<CommentModel> ? comments;
  final bool ? isCurrentUserLiking;
  final int ? totalComments;
  final int ? totalLikes;
  final double? lat;
  final double? lng;

  const DropEntity({
    this.iri,
    this.id,
    this.content,
    this.description,
    this.picturePath,
    this.isPinned,
    this.reports,
    this.contentType,
    this.user,
    this.comments,
    this.isCurrentUserLiking,
    this.totalComments,
    this.totalLikes,
    this.lat,
    this.lng
  });

  @override
  List<Object?> get props {
    return [
      iri,
      id,
      content,
      description,
      picturePath,
      isPinned,
      reports,
      contentType,
      user,
      comments,
      isCurrentUserLiking,
      totalComments,
      totalLikes,
      lat,
      lng
    ];
  }
}