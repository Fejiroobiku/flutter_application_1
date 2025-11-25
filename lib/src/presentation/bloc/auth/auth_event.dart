/// Base class for all authentication events.
abstract class AuthEvent {
  const AuthEvent();
}

/// Event fired when app starts to check authentication state.
class AppStarted extends AuthEvent {
  const AppStarted();
}

/// Event fired when user attempts to sign in with email and password.
class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested({
    required this.email,
    required this.password,
  });

  @override
  String toString() => 'SignInRequested(email: $email, password: $password)';
}

/// Event fired when user attempts to register with email and password.
class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const SignUpRequested({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  String toString() =>
      'SignUpRequested(email: $email, name: $name, password: $password)';
}

/// Event fired when user attempts to sign in with Google.
class GoogleSignInRequested extends AuthEvent {
  const GoogleSignInRequested();

  @override
  String toString() => 'GoogleSignInRequested()';
}

/// Event fired when user attempts to sign out.
class SignOutRequested extends AuthEvent {
  const SignOutRequested();

  @override
  String toString() => 'SignOutRequested()';
}
