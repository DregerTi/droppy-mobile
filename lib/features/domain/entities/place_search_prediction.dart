import 'package:equatable/equatable.dart';

class PlaceSearchPredictionEntity extends Equatable {
  final String placeId;
  final String ? description;

  const PlaceSearchPredictionEntity({
    required this.placeId,
    this.description
  });

  @override
  List<Object?> get props {
    return [
      placeId,
      description
    ];
  }
}