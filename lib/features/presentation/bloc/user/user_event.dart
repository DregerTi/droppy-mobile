abstract class UsersEvent {
  const UsersEvent();
}

class GetUsersSearch extends UsersEvent {
  final Map<String, dynamic>? params;

  const GetUsersSearch(this.params);
}

class GetUser extends UsersEvent {
  final Map<String, dynamic> params;

  const GetUser(this.params);
}

class GetMe extends UsersEvent {
  final Map<String, dynamic> params;

  const GetMe(this.params);
}

class PostUser extends UsersEvent {
  final Map<String, dynamic> params;

  const PostUser(this.params);
}

class PatchUser extends UsersEvent {
  final Map<String, dynamic> params;

  const PatchUser(this.params);
}