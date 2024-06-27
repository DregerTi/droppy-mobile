import 'package:equatable/equatable.dart';

class ReportEntity extends Equatable {
  final String ? message;
  final String ? commentIri;
  final String ? dropIri;
  final String ? commentReponseIri;
  final String ? description;

  const ReportEntity({
    this.message,
    this.commentIri,
    this.dropIri,
    this.commentReponseIri,
    this.description
  });

  @override
  List<Object?> get props {
    return [
      message,
      commentIri,
      dropIri,
      commentReponseIri,
      description
    ];
  }
}