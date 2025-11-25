import '../entities/user_entity.dart';

/// Abstract repository for authentication operations.
/// 
/// Defines contracts for all auth-related use cases including login,
/// registration, password reset, and session management.
abstract class AuthRepository {
  /// Sign in with email and password.
  /// 
  /// Returns the authenticated [UserEntity] on success.
  /// Throws exception on authentication failure.
  Future<UserEntity> signInWithEmail({
    required String email,
    required String password,
  });

  /// Register a new user with email and password.
  /// 
  /// Returns the newly created [UserEntity] on success.
  /// Throws exception if email already exists or registration fails.
  Future<UserEntity> registerWithEmail({
    required String email,
    required String password,
    required String name,
  });

  /// Sign in using Google authentication.
  /// 
  /// Returns the authenticated [UserEntity] on success.
  /// Throws exception if Google sign-in fails or is cancelled.
  Future<UserEntity> signInWithGoogle();

  /// Sign out the current user.
  /// 
  /// Clears local authentication state and tokens.
  /// Throws exception if sign-out fails.
  Future<void> signOut();

  /// Get the currently authenticated user.
  /// 
  /// Returns the current [UserEntity] if user is logged in,
  /// otherwise returns null.
  Future<UserEntity?> getCurrentUser();

  /// Send password reset email.
  /// 
  /// Sends a password reset link to the provided email address.
  /// Throws exception if email doesn't exist or sending fails.
  Future<void> sendPasswordReset({required String email});

  /// Check if user is currently logged in.
  /// 
  /// Returns true if a user session exists, false otherwise.
  Future<bool> isUserLoggedIn();
}
