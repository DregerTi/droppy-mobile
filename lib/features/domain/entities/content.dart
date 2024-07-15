import 'package:equatable/equatable.dart';

class ContentEntity extends Equatable {
  final String ? title;
  final String ? subtitle;
  final String ? picturePath;
  final String ? search;
  final String ? path;

  const ContentEntity({
    this.title,
    this.subtitle,
    this.picturePath,
    this.search,
    this.path
  });

  @override
  List<Object?> get props {
    return [
      title,
      subtitle,
      picturePath,
      search,
      path
    ];
  }
}