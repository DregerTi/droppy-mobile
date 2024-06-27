import '../../../core/ressources/data_state.dart';
import '../entities/auth.dart';

abstract class AuthRepository {

  Future<DataState<AuthEntity>> authenticate(Map<String, dynamic> credentials);

  Future<DataState<AuthEntity>> refreshToken(Map<String, dynamic> params);

  Future<DataState<AuthEntity>> authOAuthToken(Map<String, dynamic> params);

  Future<DataState<bool>> signOut();
  
}