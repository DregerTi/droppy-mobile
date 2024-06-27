import 'package:equatable/equatable.dart';

class ContentTypeEntity extends Equatable {
  final int ? id;
  final String ? name;
  final String ? description;
  final String ? picturePath;

  const ContentTypeEntity({
    this.id,
    this.name,
    this.description,
    this.picturePath
  });

  @override
  List<Object?> get props {
    return [
      id,
      name,
      description,
      picturePath
    ];
  }
}