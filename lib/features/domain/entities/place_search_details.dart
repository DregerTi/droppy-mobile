import 'package:equatable/equatable.dart';

class PlaceSearchDetailsEntity extends Equatable {
  final double lat;
  final double lng;
  final String formattedAddress;
  final String? name;
  final String placeId;
  final String? country;
  final String? zipCode;
  final String? city;

  const PlaceSearchDetailsEntity({
    required this.lat,
    required this.lng,
    required this.formattedAddress,
    this.name,
    required this.placeId,
    this.country,
    this.zipCode,
    this.city,
  });

  @override
  List<Object?> get props {
    return [
      lat,
      lng,
      formattedAddress,
      name,
      placeId,
      country,
      zipCode,
      city,
    ];
  }
}