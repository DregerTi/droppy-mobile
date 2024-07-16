import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/constants/constants.dart';
import '../../models/content.dart';

part 'content_api_service.g.dart';

@RestApi(baseUrl:apiBaseUrl)
abstract class ContentApiService {
  factory ContentApiService(Dio dio) = _ContentApiService;

  @GET("/contents/search")
  Future<HttpResponse<List<ContentModel?>?>> searchContent({
    @Query("search") required String search,
  });
}