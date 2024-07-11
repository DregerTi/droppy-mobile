import 'package:dio/dio.dart';
import 'package:droppy/features/data/models/drop.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/constants/constants.dart';

part 'drop_api_service.g.dart';

@RestApi(baseUrl:baseUrl)
abstract class DropApiService {
  factory DropApiService(Dio dio) = _DropApiService;

  @GET("/drops")
  Future<HttpResponse<List<DropModel>>> getDrops();

  @GET("/drops/{id}")
  Future<HttpResponse<DropModel>> getDrop({
    @Path("id") required int id,
  });

  @GET("/users/{id}/drops")
  Future<HttpResponse<List<DropModel>>> getUserDrops({
    @Path("id") required int id,
  });

  @POST("/drops")
  Future<HttpResponse<DropModel>> postDrop(
    @Body() Map<String, dynamic> drop,
  );

  @DELETE("/drops/{id}")
  Future<HttpResponse<dynamic>> deleteDrop({
    @Path("id") required int id,
  });

  @POST("/drops/{id}/like")
  Future<HttpResponse<DropModel>> postLike({
    @Path("id") required int id,
  });

  @DELETE("/drops/{id}/like")
  Future<HttpResponse<dynamic>> deleteLike({
    @Path("id") required int id,
  });
}