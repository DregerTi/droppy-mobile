import '../../domain/entities/place_search_details.dart';

class PlaceSearchDetailsModel extends PlaceSearchDetailsEntity {
  const PlaceSearchDetailsModel({
    required double lat,
    required double lng,
    required String formattedAddress,
    String? name,
    required String placeId
  }) : super(
    lat: lat,
    lng: lng,
    formattedAddress: formattedAddress,
    name: name,
    placeId: placeId
  );
  
  factory PlaceSearchDetailsModel.fromJson(Map<String, dynamic >map) {
    return PlaceSearchDetailsModel(
      lat: map['geometry']['location']['lat'],
      lng: map['geometry']['location']['lng'],
      formattedAddress: map['formatted_address'],
      name: map['name'] ?? '',
      placeId: map['place_id']
    );
  }

  factory PlaceSearchDetailsModel.fromEntity(PlaceSearchDetailsModel entity) {
    return PlaceSearchDetailsModel(
      lat: entity.lat,
      lng: entity.lng,
      formattedAddress: entity.formattedAddress,
      name: entity.name,
      placeId: entity.placeId
    );
  }
}