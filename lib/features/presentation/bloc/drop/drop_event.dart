abstract class DropsEvent {
  const DropsEvent();
}

class GetDrops extends DropsEvent {
  final Map<String, dynamic>? params;

  const GetDrops(this.params);
}

class GetDrop extends DropsEvent {
  final Map<String, dynamic> params;

  const GetDrop(this.params);
}

class GetUserDrops extends DropsEvent {
  final Map<String, dynamic> params;

  const GetUserDrops(this.params);
}

class PostDrop extends DropsEvent {
  final Map<String, dynamic> params;

  const PostDrop(this.params);
}

class UpdateLoadedDropsCurrentUserLike extends DropsEvent {
  final Map<String, dynamic> params;

  const UpdateLoadedDropsCurrentUserLike(this.params);
}