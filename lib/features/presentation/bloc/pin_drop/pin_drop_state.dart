import 'package:dio/dio.dart';
import 'package:droppy/features/domain/entities/drop.dart';
import 'package:equatable/equatable.dart';

abstract class PinDropState extends Equatable {
  final DropEntity ? drop;
  final DioException ? error;

  const PinDropState({ this.drop, this.error});

  @override
  List<Object?> get props => [ error];
}

class PinDropInitial extends PinDropState {
  const PinDropInitial();
}

class PostPinDropLoading extends PinDropState {
  const PostPinDropLoading();
}
class PostPinDropDone extends PinDropState {
  const PostPinDropDone(DropEntity? drop) : super(drop: drop);
}
class PostPinDropError extends PinDropState {
  const PostPinDropError(DioException error) : super(error: error);
}

class DeletePinDropLoading extends PinDropState {
  const DeletePinDropLoading();
}
class DeletePinDropDone extends PinDropState {
  const DeletePinDropDone(DropEntity? drop) : super(drop: drop);
}
class DeletePinDropError extends PinDropState {
  const DeletePinDropError(DioException error) : super(error: error);
}