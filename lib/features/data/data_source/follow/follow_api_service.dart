import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/constants/constants.dart';
import '../../models/follow.dart';

part 'follow_api_service.g.dart';

@RestApi(baseUrl:baseUrl)
abstract class FollowApiService {
  factory FollowApiService(Dio dio) = _FollowApiService;

  @POST("/follows")
  Future<HttpResponse<FollowModel>> postFollow(
    @Body() Map<String, dynamic> params
  );

  @DELETE("/follows/{id}")
  Future<HttpResponse<Map<String, dynamic>>> deleteFollow({
    @Path("id") required int id,
  });

  @POST("/follows/accept/{id}")
  Future<HttpResponse<FollowModel>> acceptFollow({
    @Path("id") required int id,
  });

  @DELETE("/follows/refuse/{id}")
  Future<HttpResponse<Map<String, dynamic>>> refuseFollow({
    @Path("id") required int id,
  });
}