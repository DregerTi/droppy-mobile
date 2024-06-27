abstract class PlaceSearchEvent {
  const PlaceSearchEvent();
}

class GetPlaceAutocomplete extends PlaceSearchEvent {
  final Map<String, dynamic>? params;

  const GetPlaceAutocomplete(this.params);
}

class GetPlaceDetails extends PlaceSearchEvent {
  final Map<String, dynamic> params;

  const GetPlaceDetails(this.params);
}

class GetPlaceReverseGeocoding extends PlaceSearchEvent {
  final Map<String, dynamic> params;

  const GetPlaceReverseGeocoding(this.params);
}