import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/constants/constants.dart';
import '../../models/comment_response.dart';

part 'comment_response_api_service.g.dart';

@RestApi(baseUrl:apiBaseUrl)
abstract class CommentResponseApiService {
  factory CommentResponseApiService(Dio dio) = _CommentResponseApiService;

  @POST("/comments/{commentId}/responses")
  Future<HttpResponse<CommentResponseModel>> postCommentResponse({
    @Path("commentId") required int commentId,
    @Body() required Map<String, dynamic> commentResponse,
  });
}