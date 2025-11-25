import 'package:here_bro/src/domain/entities/user_entity.dart';

/// Base class for all authentication states.
abstract class AuthState {
  const AuthState();
}

/// Initial state before any authentication event.
class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  String toString() => 'AuthInitial()';
}

/// State while authentication operations are in progress.
/// 
/// Used during sign-in, sign-up, sign-out, and initial app load.
class Authenticating extends AuthState {
  const Authenticating();

  @override
  String toString() => 'Authenticating()';
}

/// State when user is authenticated and logged in.
/// 
/// Contains the authenticated user information.
class Authenticated extends AuthState {
  final UserEntity user;

  const Authenticated(this.user);

  @override
  String toString() => 'Authenticated(user: ${user.name})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Authenticated &&
          runtimeType == other.runtimeType &&
          user == other.user;

  @override
  int get hashCode => user.hashCode;
}

/// State when user is not authenticated (logged out).
class Unauthenticated extends AuthState {
  const Unauthenticated();

  @override
  String toString() => 'Unauthenticated()';
}

/// State when an authentication error occurs.
/// 
/// Contains error message to display to user.
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  String toString() => 'AuthError(message: $message)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}
