import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/constants/constants.dart';
import '../../models/like.dart';

part 'like_api_service.g.dart';

@RestApi(baseUrl:apiBaseUrl)
abstract class LikeApiService {
  factory LikeApiService(Dio dio) = _LikeApiService;

  @GET("/users/{userId}/likes")
  Future<HttpResponse<List<LikeModel>>> getUserLikes({
    @Path("userId") required int userId,
  });

  @POST("/likes")
  Future<HttpResponse<LikeModel>> postLike(
    @Body() Map<String, dynamic> params
  );

  @DELETE("/likes/{likeId}")
  Future<HttpResponse<Map<String, dynamic>>> deleteLike({
    @Path("likeId") required int likeId,
  });
}