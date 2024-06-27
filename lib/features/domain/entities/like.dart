import 'package:droppy/features/data/models/drop.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/user.dart';

class LikeEntity extends Equatable {
  final int ? id;
  final DropModel ? drop;
  final String ? dropIri;
  final UserModel ? user;

  const LikeEntity({
    this.id,
    this.drop,
    this.dropIri,
    this.user,
  });

  @override
  List<Object?> get props {
    return [
      id,
      drop,
      dropIri,
      user,
    ];
  }
}