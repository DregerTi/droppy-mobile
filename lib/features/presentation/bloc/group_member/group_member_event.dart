abstract class GroupMembersEvent {
  const GroupMembersEvent();
}

class LeaveGroup extends GroupMembersEvent {
  final Map<String, dynamic>? params;

  const LeaveGroup(this.params);
}

class PostGroupJoin extends GroupMembersEvent {
  final Map<String, dynamic> params;

  const PostGroupJoin(this.params);
}

class PostGroupMember extends GroupMembersEvent {
  final Map<String, dynamic> params;

  const PostGroupMember(this.params);
}