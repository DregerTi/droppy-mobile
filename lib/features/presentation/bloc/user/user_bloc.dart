import 'package:droppy/features/presentation/bloc/user/user_event.dart';
import 'package:droppy/features/presentation/bloc/user/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/ressources/data_state.dart';
import '../../../domain/usecases/user/get_user.dart';
import '../../../domain/usecases/user/get_users.dart';
import '../../../domain/usecases/user/patch_user.dart';
import '../../../domain/usecases/user/post_user.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {

  final GetUsersUseCase _getUsersUseCase;
  final GetUserUseCase _getUserUseCase;
  final PostUserUseCase _postUserUseCase;
  final PatchUserUseCase _patchUserUseCase;

  UsersBloc(
    this._getUsersUseCase,
    this._getUserUseCase,
    this._postUserUseCase,
    this._patchUserUseCase,
  ) : super(const UsersLoading()){
    on <GetUsers> (onGetUsers);
    on <GetUser> (onGetUser);
    on <PostUser> (onPostUser);
    on <PatchUser> (onPatchUser);
    on <GetMe> (onGetMe);
  }

  void onGetUsers(GetUsers event, Emitter<UsersState> emit) async {
    emit(
      const UsersLoading()
    );
    final dataState = await _getUsersUseCase();

    if(dataState is DataSuccess && dataState.data!.isNotEmpty){
      emit(
        UsersDone(dataState.data!)
      );
    }

    if(dataState is DataFailed){
      emit(
        UsersError(dataState.error!)
      );
    }
  }

  void onGetUser(GetUser event, Emitter<UsersState> emit) async {
    emit(
      const UserLoading()
    );
    final dataState = await _getUserUseCase(params: event.params);

    print(dataState.data!);

    if(dataState is DataSuccess){
      emit(
        UserDone(dataState.data!)
      );
    }

    if(dataState is DataFailed){
      emit(
        UserError(dataState.error!)
      );
    }
  }

  void onGetMe(GetMe event, Emitter<UsersState> emit) async {
    emit(
        const MeLoading()
    );
    final dataState = await _getUserUseCase(params: event.params);

    print(dataState.data!);
    if(dataState is DataSuccess){
      print('ok');
      emit(
          MeDone(dataState.data!)
      );
    }

    if(dataState is DataFailed){
      emit(
          MeError(dataState.error!)
      );
    }
  }

  void onPostUser(PostUser event, Emitter<UsersState> emit) async {
    emit(
      const PostUserLoading()
    );
    final dataState = await _postUserUseCase(params: event.params);

    if(dataState is DataSuccess){
      emit(
        PostUserDone(dataState.data!)
      );
    }

    if(dataState is DataFailed){
      emit(
        PostUserError(dataState.error!)
      );
    }
  }

  void onPatchUser(PatchUser event, Emitter<UsersState> emit) async {
    emit(
      const PatchUserLoading()
    );
    final dataState = await _patchUserUseCase(params: event.params);

    if(dataState is DataSuccess){
      emit(
        PatchUserDone(dataState.data!)
      );
    }

    if(dataState is DataFailed){
      emit(
        PatchUserError(dataState.error!)
      );
    }
  }
}