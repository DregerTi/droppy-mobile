abstract class GroupsEvent {
  const GroupsEvent();
}

class GetGroups extends GroupsEvent {
  final Map<String, dynamic>? params;

  const GetGroups(this.params);
}

class GetGroup extends GroupsEvent {
  final Map<String, dynamic> params;

  const GetGroup(this.params);
}


class PostGroup extends GroupsEvent {
  final Map<String, dynamic> params;

  const PostGroup(this.params);
}


class PatchGroup extends GroupsEvent {
  final Map<String, dynamic> params;

  const PatchGroup(this.params);
}