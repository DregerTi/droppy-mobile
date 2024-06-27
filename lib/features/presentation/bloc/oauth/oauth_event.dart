abstract class OAuthEvent {
  const OAuthEvent();
}

class SignInWithGoogle extends OAuthEvent {
  const SignInWithGoogle();
}

class SignInWithApple extends OAuthEvent {
  const SignInWithApple();
}