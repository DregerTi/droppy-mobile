import '../../../core/ressources/data_state.dart';
import '../entities/group.dart';
import '../entities/group_member.dart';

abstract class GroupRepository {

  Future<DataState<List<GroupEntity?>?>> getGroups(Map<String, dynamic> params);

  Future<DataState<GroupEntity>> getGroup(Map<String, dynamic> params);

  Future<DataState<GroupEntity>> patchGroup(Map<String, dynamic> params);

  Future<DataState<GroupMemberEntity>> postGroupJoin(Map<String, dynamic> params);

  Future<DataState<Map<String, dynamic>>> leaveGroup(Map<String, dynamic> params);

  Future<DataState<GroupMemberEntity>> postGroupMember(Map<String, dynamic> params);

  Future<DataState<GroupEntity>> postGroup(Map<String, dynamic> params);

  Future<DataState<GroupEntity?>> getGroupFeed(Map<String, dynamic> params);

}