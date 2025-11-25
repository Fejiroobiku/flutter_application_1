import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'auth_user.dart';

/// Data source for Firebase Authentication operations.
/// 
/// Handles all direct interactions with Firebase Auth including email/password
/// authentication, Google sign-in, and session management.
class FirebaseAuthDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthDataSource({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn;

  /// Sign up with email and password.
  /// 
  /// Creates a new user account with the provided credentials.
  /// Throws [FirebaseAuthException] if email already exists or validation fails.
  /// Returns [AuthUser] with uid and email on success.
  Future<AuthUser> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('User creation failed');
      }

      // Update display name
      await user.updateDisplayName(name);
      await user.reload();

      return AuthUser(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? name,
        photoUrl: user.photoURL,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  /// Sign in with email and password.
  /// 
  /// Authenticates user with the provided credentials.
  /// Throws [FirebaseAuthException] if credentials are invalid.
  /// Returns [AuthUser] with uid and email on success.
  Future<AuthUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Sign in failed');
      }

      return AuthUser(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? '',
        photoUrl: user.photoURL,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  /// Sign in with Google.
  /// 
  /// Opens Google sign-in flow and authenticates with Firebase.
  /// Throws exception if sign-in is cancelled or fails.
  /// Returns [AuthUser] with uid and email on success.
  Future<AuthUser> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign-in cancelled');
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Google sign-in failed');
      }

      return AuthUser(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? '',
        photoUrl: user.photoURL,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Google sign-in failed: $e');
    }
  }

  /// Sign out the current user.
  /// 
  /// Clears Firebase Auth session and Google sign-in cache.
  /// Throws exception if sign-out fails.
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  /// Get the currently authenticated user.
  /// 
  /// Returns [AuthUser] if user is logged in, null otherwise.
  /// Does not require network call - uses local cached session.
  AuthUser? getCurrentUser() {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    return AuthUser(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? '',
      photoUrl: user.photoURL,
    );
  }

  /// Check if user is currently authenticated.
  /// 
  /// Returns true if a valid session exists, false otherwise.
  bool isUserLoggedIn() => _firebaseAuth.currentUser != null;

  /// Get the current user's ID token.
  /// 
  /// Used for authenticated API calls.
  /// Returns the ID token string.
  /// Throws exception if user is not authenticated.
  Future<String> getIdToken() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    return await user.getIdToken();
  }

  /// Send password reset email.
  /// 
  /// Sends a password reset link to the provided email address.
  /// Throws [FirebaseAuthException] if email doesn't exist.
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  /// Stream authentication state changes.
  /// 
  /// Emits [AuthUser] when user logs in, null when user logs out.
  /// Useful for reactive UI updates based on authentication state.
  /// 
  /// Example:
  /// ```dart
  /// dataSource.authStateStream().listen((user) {
  ///   if (user != null) {
  ///     print('User logged in: ${user.email}');
  ///   } else {
  ///     print('User logged out');
  ///   }
  /// });
  /// ```
  Stream<AuthUser?> authStateStream() {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;

      return AuthUser(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? '',
        photoUrl: user.photoURL,
      );
    });
  }

  /// Handle Firebase Auth exceptions and convert to meaningful messages.
  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return Exception('Password is too weak');
      case 'email-already-in-use':
        return Exception('Email already in use');
      case 'invalid-email':
        return Exception('Invalid email address');
      case 'user-not-found':
        return Exception('User not found');
      case 'wrong-password':
        return Exception('Wrong password');
      case 'user-disabled':
        return Exception('User account is disabled');
      case 'too-many-requests':
        return Exception('Too many attempts. Try again later');
      case 'operation-not-allowed':
        return Exception('This operation is not allowed');
      default:
        return Exception('Auth error: ${e.message}');
    }
  }
}
