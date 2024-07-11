import '../../../core/ressources/data_state.dart';
import '../entities/user.dart';

abstract class UserRepository {

  Future<DataState<List<UserEntity>>> getUsers();

  Future<DataState<List<UserEntity?>?>> getUsersSearch(Map<String, dynamic> params);

  Future<DataState<UserEntity>> getUser(Map<String, dynamic> params);

  Future<DataState<UserEntity>> postUser(Map<String, dynamic> user);

  Future<DataState<UserEntity>> patchUser(Map<String, dynamic> user);

  Future<DataState<List<UserEntity?>?>> getUserFollowers(Map<String, dynamic> params);

  Future<DataState<List<UserEntity?>?>> getUserFollowed(Map<String, dynamic> params);

}