import 'package:dio/dio.dart';
import 'package:droppy/features/data/models/drop.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/constants/constants.dart';
import '../../models/group.dart';
import '../../models/group_member.dart';

part 'group_api_service.g.dart';

@RestApi(baseUrl:baseUrl)
abstract class GroupApiService {
  factory GroupApiService(Dio dio) = _GroupApiService;

  @GET("/groups/search")
  Future<HttpResponse<List<GroupModel?>?>> getGroups({
    @Query("search") required String search,
  });

  @GET("/groups/{id}")
  Future<HttpResponse<GroupModel>> getGroup({
    @Path("id") required int id,
  });

  @PATCH("/groups/{id}")
  Future<HttpResponse<GroupModel>> patchGroup({
    @Path("id") required int id,
    @Body() required Map<String, dynamic> group,
  });

  @POST("/groups/members/{id}/join")
  Future<HttpResponse<GroupMemberModel>> postGroupJoin({
    @Path("id") required int id,
  });

  @DELETE("/groups/members/{id}/{memberId}")
  Future<HttpResponse<Map<String, dynamic>>> leaveGroup({
    @Path("id") required int id,
    @Path("memberId") required int memberId,
  });

  @POST("/groups/members/{id}/{memberId}")
  Future<HttpResponse<GroupMemberModel>> postGroupMember({
    @Path("id") required int id,
    @Path("memberId") required int memberId,
  });

  @POST("/groups")
  Future<HttpResponse<GroupModel>> postGroup(
    @Body() Map<String, dynamic> group,
  );

  @GET("/groups/{id}/feed")
  Future<HttpResponse<GroupModel?>> getGroupFeed({
    @Path("id") required int id,
  });
}