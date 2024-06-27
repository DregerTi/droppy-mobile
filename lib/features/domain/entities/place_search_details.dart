import 'package:equatable/equatable.dart';

class PlaceSearchDetailsEntity extends Equatable {
  final double lat;
  final double lng;
  final String formattedAddress;
  final String? name;
  final String placeId;

  const PlaceSearchDetailsEntity({
    required this.lat,
    required this.lng,
    required this.formattedAddress,
    this.name,
    required this.placeId
  });

  @override
  List<Object?> get props {
    return [
      lat,
      lng,
      formattedAddress,
      name,
      placeId
    ];
  }
}