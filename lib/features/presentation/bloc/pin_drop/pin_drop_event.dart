abstract class PinDropEvent {
  const PinDropEvent();
}

class PostPinDrop extends PinDropEvent {
  final Map<String, dynamic> params;

  const PostPinDrop(this.params);
}

class DeletePinDrop extends PinDropEvent {
  final Map<String, dynamic> params;

  const DeletePinDrop(this.params);
}