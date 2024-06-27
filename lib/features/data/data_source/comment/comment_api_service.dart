import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/constants/constants.dart';
import '../../models/comment.dart';

part 'comment_api_service.g.dart';

@RestApi(baseUrl:baseUrl)
abstract class CommentApiService {
  factory CommentApiService(Dio dio) = _CommentApiService;

  @POST("/comments")
  Future<HttpResponse<CommentModel>> postComment(
    @Body() Map<String, dynamic> comment,
  );
}