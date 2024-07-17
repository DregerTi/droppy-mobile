import '../../domain/entities/place_search_details.dart';

class PlaceSearchDetailsModel extends PlaceSearchDetailsEntity {
  const PlaceSearchDetailsModel({
    required double lat,
    required double lng,
    required String formattedAddress,
    String? name,
    required String placeId,
    String? country,
    String? zipCode,
    String? city,
  }) : super(
    lat: lat,
    lng: lng,
    formattedAddress: formattedAddress,
    name: name,
    placeId: placeId,
    country: country,
    zipCode: zipCode,
    city: city,
  );

  factory PlaceSearchDetailsModel.fromJson(Map<String, dynamic >map) {
    String? streetNumber;
    String? route;
    String? country;
    String? zipCode;
    String? city;

    for (var component in map['address_components']) {
      if (component['types'].contains('street_number')) {
        streetNumber = component['long_name'];
      } else if (component['types'].contains('route')) {
        route = component['long_name'];
      } else if (component['types'].contains('country')) {
        country = component['long_name'];
      } else if (component['types'].contains('postal_code')) {
        zipCode = component['long_name'];
      } else if (component['types'].contains('locality')) {
        city = component['long_name'];
      }
    }

    String formattedAddress = (streetNumber != null && route != null) ? '$streetNumber $route' : '';

    return PlaceSearchDetailsModel(
      lat: map['geometry']['location']['lat'],
      lng: map['geometry']['location']['lng'],
      formattedAddress: formattedAddress,
      name: map['name'] ?? '',
      placeId: map['place_id'],
      country: country,
      zipCode: zipCode,
      city: city,
    );
  }

  factory PlaceSearchDetailsModel.fromEntity(PlaceSearchDetailsModel entity) {
    return PlaceSearchDetailsModel(
      lat: entity.lat,
      lng: entity.lng,
      formattedAddress: entity.formattedAddress,
      name: entity.name,
      placeId: entity.placeId,
      country: entity.country,
      zipCode: entity.zipCode,
      city: entity.city,
    );
  }
}