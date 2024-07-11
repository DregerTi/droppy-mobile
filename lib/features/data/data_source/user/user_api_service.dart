import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/constants/constants.dart';
import '../../models/user.dart';

part 'user_api_service.g.dart';

@RestApi(baseUrl:baseUrl)
abstract class UserApiService {
  factory UserApiService(Dio dio) = _UserApiService;

  @GET("/users")
  Future<HttpResponse<List<UserModel>>> getUsers({
    @Query("page") int ? page,
  });

  @GET("/users/search")
  Future<HttpResponse<List<UserModel?>?>> getUsersSearch({
    @Query("search") required String search,
  });

  @GET("/users/{id}")
  Future<HttpResponse<UserModel>> getUser({
    @Path("id") required int id,
  });

  @POST("/users")
  Future<HttpResponse<UserModel>> postUser(
    @Body() Map<String, dynamic> user,
  );

  @PATCH("/users/{id}")
  Future<HttpResponse<UserModel>> patchUser({
    @Path("id") required int id,
    @Body() required Map<String, dynamic> user,
  });

  @GET("/users/{id}/followers")
  Future<HttpResponse<List<UserModel?>?>> getUserFollowers({
    @Path("id") required int id,
  });

  @GET("/users/{id}/followed")
  Future<HttpResponse<List<UserModel?>?>> getUserFollowed({
    @Path("id") required int id,
  });
}