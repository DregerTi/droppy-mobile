import 'package:dio/dio.dart';
import 'package:droppy/features/data/data_source/goup/group_api_service.dart';
import 'package:droppy/features/domain/repository/follow_repository.dart';
import 'package:droppy/features/domain/usecases/drop/get_drops.dart';
import 'package:droppy/features/domain/usecases/group/get_group_feed.dart';
import 'package:droppy/features/domain/usecases/group/get_groups.dart';
import 'package:droppy/features/domain/usecases/group_member/leave_group.dart';
import 'package:droppy/features/presentation/bloc/feed/feed_bloc.dart';
import 'package:get_it/get_it.dart';
import 'core/util/http_overrides.dart';
import 'features/data/data_source/auth/auth_api_service.dart';
import 'features/data/data_source/comment/comment_api_service.dart';
import 'features/data/data_source/drop/drop_api_service.dart';
import 'features/data/data_source/follow/follow_api_service.dart';
import 'features/data/data_source/like/like_api_service.dart';
import 'features/data/data_source/place_search/place_search_api_service.dart';
import 'features/data/data_source/report/report_api_service.dart';
import 'features/data/data_source/user/user_api_service.dart';
import 'features/data/repository/auth_repository_impl.dart';
import 'features/data/repository/comment_repository_impl.dart';
import 'features/data/repository/drop_repository_impl.dart';
import 'features/data/repository/follow_repository_impl.dart';
import 'features/data/repository/group_repository_impl.dart';
import 'features/data/repository/like_repository_impl.dart';
import 'features/data/repository/place_search_repository_impl.dart';
import 'features/data/repository/report_repository_impl.dart';
import 'features/data/repository/user_repository_impl.dart';
import 'features/domain/repository/auth_repository.dart';
import 'features/domain/repository/comment_repository.dart';
import 'features/domain/repository/drop_repository.dart';
import 'features/domain/repository/group_repository.dart';
import 'features/domain/repository/like_repository.dart';
import 'features/domain/repository/place_search_repository.dart';
import 'features/domain/repository/report_repository.dart';
import 'features/domain/repository/user_repository.dart';
import 'features/domain/usecases/auth/auth_oauth_token.dart';
import 'features/domain/usecases/auth/authenticate.dart';
import 'features/domain/usecases/auth/refresh_token.dart';
import 'features/domain/usecases/auth/sign_out.dart';
import 'features/domain/usecases/comment/post_comment.dart';
import 'features/domain/usecases/drop/get_drop.dart';
import 'features/domain/usecases/drop/get_user_drops.dart';
import 'features/domain/usecases/drop/post_drop.dart';
import 'features/domain/usecases/follow/accept_follow.dart';
import 'features/domain/usecases/follow/delete_follow.dart';
import 'features/domain/usecases/follow/post_follow.dart';
import 'features/domain/usecases/follow/refuse_follow.dart';
import 'features/domain/usecases/group/get_group.dart';
import 'features/domain/usecases/group/patch_group.dart';
import 'features/domain/usecases/group/post_group.dart';
import 'features/domain/usecases/group_member/post_group_join.dart';
import 'features/domain/usecases/group_member/post_group_member.dart';
import 'features/domain/usecases/like/delete_like.dart';
import 'features/domain/usecases/like/post_like.dart';
import 'features/domain/usecases/place_search/get_place_autocomplete.dart';
import 'features/domain/usecases/place_search/get_place_details.dart';
import 'features/domain/usecases/place_search/get_place_reverse_geocoding.dart';
import 'features/domain/usecases/report/post_report.dart';
import 'features/domain/usecases/user/get_user.dart';
import 'features/domain/usecases/user/get_users_followed.dart';
import 'features/domain/usecases/user/get_users_followers.dart';
import 'features/domain/usecases/user/get_users_search.dart';
import 'features/domain/usecases/user/patch_user.dart';
import 'features/domain/usecases/user/post_user.dart';
import 'features/presentation/bloc/auth/auth_bloc.dart';
import 'features/presentation/bloc/comment/remote/comment_bloc.dart';
import 'features/presentation/bloc/drop/drop_bloc.dart';
import 'features/presentation/bloc/follow/follow_bloc.dart';
import 'features/presentation/bloc/follow/get/follow_get_bloc.dart';
import 'features/presentation/bloc/group/feed/goup_feed_bloc.dart';
import 'features/presentation/bloc/group/goup_bloc.dart';
import 'features/presentation/bloc/group_member/goup_member_bloc.dart';
import 'features/presentation/bloc/lang/lang_bloc.dart';
import 'features/presentation/bloc/like/like_bloc.dart';
import 'features/presentation/bloc/oauth/oauth_bloc.dart';
import 'features/presentation/bloc/place_search/place_search_bloc.dart';
import 'features/presentation/bloc/report/report_bloc.dart';
import 'features/presentation/bloc/user/user_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {

  final localHttpOverrides = LocalHttpOverrides();
  final dio = await localHttpOverrides.withAuthInterceptor();
  sl.registerSingleton<Dio>(dio);

  sl.registerFactory<LangBloc>(
        () => LangBloc(),
  );

  sl.registerSingleton<DropApiService>(DropApiService(sl()));
  sl.registerSingleton<DropRepository>(DropRepositoryImpl(sl()));
  sl.registerSingleton<GetDropUseCase>(GetDropUseCase(sl()));
  sl.registerSingleton<GetDropsUseCase>(GetDropsUseCase(sl()));
  sl.registerSingleton<GetUserDropsUseCase>(GetUserDropsUseCase(sl()));
  sl.registerSingleton<PostDropUseCase>(PostDropUseCase(sl()));
  sl.registerFactory<DropsBloc>(
    () => DropsBloc(sl(), sl(), sl(), sl()),
  );

  sl.registerSingleton<GroupApiService>(GroupApiService(sl()));
  sl.registerSingleton<GroupRepository>(GroupRepositoryImpl(sl()));
  sl.registerSingleton<GetGroupUseCase>(GetGroupUseCase(sl()));
  sl.registerSingleton<GetGroupsUseCase>(GetGroupsUseCase(sl()));
  sl.registerSingleton<PostGroupUseCase>(PostGroupUseCase(sl()));
  sl.registerSingleton<PatchGroupUseCase>(PatchGroupUseCase(sl()));
  sl.registerFactory<GroupsBloc>(
    () => GroupsBloc(sl(), sl(), sl(), sl()),
  );

  sl.registerSingleton<LeaveGroupUseCase>(LeaveGroupUseCase(sl()));
  sl.registerSingleton<PostGroupJoinUseCase>(PostGroupJoinUseCase(sl()));
  sl.registerSingleton<PostGroupMemberUseCase>(PostGroupMemberUseCase(sl()));
  sl.registerFactory<GroupMembersBloc>(
    () => GroupMembersBloc(sl(), sl(), sl()),
  );

  sl.registerSingleton<CommentApiService>(CommentApiService(sl()));
  sl.registerSingleton<CommentRepository>(CommentRepositoryImpl(sl()));
  sl.registerSingleton<PostCommentUseCase>(PostCommentUseCase(sl()));
  sl.registerFactory<CommentsBloc>(
    () => CommentsBloc(sl()),
  );

  sl.registerSingleton<ReportApiService>(ReportApiService(sl()));
  sl.registerSingleton<ReportRepository>(ReportRepositoryImpl(sl()));
  sl.registerSingleton<PostReportUseCase>(PostReportUseCase(sl()));
  sl.registerFactory<ReportsBloc>(
        () => ReportsBloc(sl()),
  );

  sl.registerSingleton<LikeApiService>(LikeApiService(sl()));
  sl.registerSingleton<LikeRepository>(LikeRepositoryImpl(sl()));
  sl.registerSingleton<PostLikeUseCase>(PostLikeUseCase(sl()));
  sl.registerSingleton<DeleteLikeUseCase>(DeleteLikeUseCase(sl()));
  sl.registerFactory<LikesBloc>(
    () => LikesBloc(sl(), sl()),
  );

  sl.registerSingleton<UserApiService>(UserApiService(sl()));
  sl.registerSingleton<UserRepository>(UserRepositoryImpl(sl()));
  sl.registerSingleton<GetUsersSearchUseCase>(GetUsersSearchUseCase(sl()));
  sl.registerSingleton<GetUserUseCase>(GetUserUseCase(sl()));
  sl.registerSingleton<PostUserUseCase>(PostUserUseCase(sl()));
  sl.registerSingleton<PatchUserUseCase>(PatchUserUseCase(sl()));
  sl.registerFactory<UsersBloc>(
    () => UsersBloc(sl(), sl(), sl(), sl()),
  );

  sl.registerSingleton<GetUserFollowersUseCase>(GetUserFollowersUseCase(sl()));
  sl.registerSingleton<GetUserFollowedUseCase>(GetUserFollowedUseCase(sl()));
  sl.registerFactory<FollowGetBloc>(
    () => FollowGetBloc(sl(), sl()),
  );

  sl.registerSingleton<AuthApiService>(AuthApiService(sl()));
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl(sl()));
  sl.registerSingleton<AuthenticateUseCase>(AuthenticateUseCase(sl()));
  sl.registerSingleton<SignOutUseCase>(SignOutUseCase(sl()));
  sl.registerSingleton<RefreshTokenUseCase>(RefreshTokenUseCase(sl()));
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(sl(), sl(), sl())
  );

  sl.registerSingleton<AuthOAuthTokenUseCase>(AuthOAuthTokenUseCase(sl()));
  sl.registerFactory<OAuthBloc>(
    () => OAuthBloc(sl())
  );

  sl.registerSingleton<PlaceSearchApiService>(PlaceSearchApiService(sl()));
  sl.registerSingleton<PlaceSearchRepository>(PlaceSearchRepositoryImpl(sl()));
  sl.registerSingleton<GetPlaceAutocompleteUseCase>(GetPlaceAutocompleteUseCase(sl()));
  sl.registerSingleton<GetPlaceDetailsUseCase>(GetPlaceDetailsUseCase(sl()));
  sl.registerSingleton<GetPlaceReverseGeocodingUseCase>(GetPlaceReverseGeocodingUseCase(sl()));
  sl.registerFactory<PlaceSearchBloc>(
    () => PlaceSearchBloc(sl(), sl(), sl())
  );

  sl.registerSingleton<FollowApiService>(FollowApiService(sl()));
  sl.registerSingleton<FollowRepository>(FollowRepositoryImpl(sl()));
  sl.registerSingleton<PostFollowUseCase>(PostFollowUseCase(sl()));
  sl.registerSingleton<DeleteFollowUseCase>(DeleteFollowUseCase(sl()));
  sl.registerSingleton<AcceptFollowUseCase>(AcceptFollowUseCase(sl()));
  sl.registerSingleton<RefuseFollowUseCase>(RefuseFollowUseCase(sl()));
  sl.registerFactory<FollowsBloc>(
    () => FollowsBloc(sl(), sl(), sl(), sl())
  );

  sl.registerSingleton<GetGroupFeedUseCase>(GetGroupFeedUseCase(sl()));
  sl.registerFactory<GroupFeedBloc>(
    () => GroupFeedBloc(sl())
  );

  sl.registerFactory<FeedBloc>(
    () => FeedBloc()
  );
}

