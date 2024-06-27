import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../core/ressources/data_state.dart';
import '../../../domain/usecases/auth/auth_oauth_token.dart';
import 'oauth_event.dart';
import 'oauth_state.dart';

class OAuthBloc extends Bloc<OAuthEvent, OAuthState> {

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthOAuthTokenUseCase _authTokenUseCase;

  OAuthBloc(
      this._authTokenUseCase
      ) : super(OAuthInit()){
    on<SignInWithGoogle>(onSignInWithGoogle);
  }

  void onSignInWithGoogle(SignInWithGoogle event, Emitter<OAuthState> emit) async {
    emit(
      OAuthLoading()
    );
    try {
      final googleUser = await _googleSignIn.signIn();

      if(googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      final user = _auth.currentUser;
      final idToken = await user?.getIdToken();
      final dataState = await _authTokenUseCase(params: {'id_token': idToken});
      if(dataState is DataSuccess && dataState.data != null){
        emit(
          OAuthDone(dataState.data!)
        );
      }
    } catch (e) {
      emit(
        OAuthError(e.toString())
      );
    }
  }
}