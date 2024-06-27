import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/constants/constants.dart';
import '../../models/auth.dart';

part 'auth_api_service.g.dart';

@RestApi(baseUrl:baseUrl)
abstract class AuthApiService {
  factory AuthApiService(Dio dio) = _AuthApiService;

  @POST("/auth")
  Future<HttpResponse<AuthModel>> authenticate(
    @Body() Map<String, dynamic> credentials
  );

  @POST("/auth/refresh")
  Future<HttpResponse<AuthModel>> refreshToken(
    @Body() Map<String, dynamic> refreshToken
  );

  @POST("/auth/oauth_token")
  Future<HttpResponse<AuthModel>> authOAuthToken(
    @Body() Map<String, dynamic> idToken
  );
}
