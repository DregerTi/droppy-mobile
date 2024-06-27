import '../../domain/entities/place_search_prediction.dart';

class PlaceSearchPredictionModel extends PlaceSearchPredictionEntity {
  const PlaceSearchPredictionModel({
    required String placeId,
    String ? description,
  }) : super(
    placeId: placeId,
    description: description,
  );
  
  factory PlaceSearchPredictionModel.fromJson(Map<String, dynamic >map) {
    return PlaceSearchPredictionModel(
      placeId: map['place_id'],
      description: map['description'] ?? "",
    );
  }

  factory PlaceSearchPredictionModel.fromEntity(PlaceSearchPredictionModel entity) {
    return PlaceSearchPredictionModel(
      placeId: entity.placeId,
      description: entity.description,
    );
  }
}