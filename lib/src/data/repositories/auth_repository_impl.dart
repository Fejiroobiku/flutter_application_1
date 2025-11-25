import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/utils/local_storage_service.dart';
import '../datasources/firebase_auth_datasource.dart';
import '../models/user.dart';

/// Concrete implementation of [AuthRepository].
///
/// Coordinates between [FirebaseAuthDataSource] and the domain layer.
/// Manages user session state, handles data transformation (AuthUser -> UserEntity),
/// and persists authentication tokens to local storage.
///
/// Error handling strategy:
/// - Network errors and Firebase exceptions are caught and rethrown
/// - User-facing error messages are logged but allow BLoC to handle display
/// - Local storage failures are treated as critical errors
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _dataSource;
  final LocalStorageService _localStorageService;

  AuthRepositoryImpl({
    required FirebaseAuthDataSource dataSource,
    required LocalStorageService localStorageService,
  })  : _dataSource = dataSource,
        _localStorageService = localStorageService;

  @override
  Future<UserEntity> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // Authenticate with Firebase
      final authUser = await _dataSource.signInWithEmail(
        email: email,
        password: password,
      );

      // Persist user data locally
      await _localStorageService.setUserId(authUser.uid);
      await _localStorageService.setUserEmail(authUser.email);
      await _localStorageService.setUserName(authUser.displayName);

      // Get ID token for future API calls
      final idToken = await _dataSource.getIdToken();
      await _localStorageService.setAuthToken(idToken);

      return _mapAuthUserToEntity(authUser);
    } catch (e) {
      print('Error signing in with email: $e');
      // Clear any partial data on failure
      await _localStorageService.clearUserData();
      rethrow;
    }
  }

  @override
  Future<UserEntity> registerWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Create user account in Firebase
      final authUser = await _dataSource.signUpWithEmail(
        email: email,
        password: password,
        name: name,
      );

      // Persist user data locally
      await _localStorageService.setUserId(authUser.uid);
      await _localStorageService.setUserEmail(authUser.email);
      await _localStorageService.setUserName(authUser.displayName);

      // Get ID token for future API calls
      final idToken = await _dataSource.getIdToken();
      await _localStorageService.setAuthToken(idToken);

      return _mapAuthUserToEntity(authUser);
    } catch (e) {
      print('Error registering with email: $e');
      // Clean up on failure
      await _localStorageService.clearUserData();
      rethrow;
    }
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    try {
      // Authenticate with Google via Firebase
      final authUser = await _dataSource.signInWithGoogle();

      // Persist user data locally
      await _localStorageService.setUserId(authUser.uid);
      await _localStorageService.setUserEmail(authUser.email);
      await _localStorageService.setUserName(authUser.displayName);

      // Get ID token for future API calls
      final idToken = await _dataSource.getIdToken();
      await _localStorageService.setAuthToken(idToken);

      return _mapAuthUserToEntity(authUser);
    } catch (e) {
      print('Error signing in with Google: $e');
      // Clear any partial data on failure
      await _localStorageService.clearUserData();
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      // Sign out from Firebase
      await _dataSource.signOut();

      // Clear local user data
      await _localStorageService.clearUserData();
    } catch (e) {
      print('Error signing out: $e');
      // Even if Firebase sign-out fails, clear local data
      await _localStorageService.clearUserData();
      rethrow;
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      // Check local cache first
      final userId = _localStorageService.getUserId();
      if (userId == null) {
        return null;
      }

      // Get current user from Firebase (may return null if session expired)
      final authUser = _dataSource.getCurrentUser();
      if (authUser == null) {
        // Clear stale local data
        await _localStorageService.clearUserData();
        return null;
      }

      return _mapAuthUserToEntity(authUser);
    } catch (e) {
      print('Error getting current user: $e');
      rethrow;
    }
  }

  @override
  Future<bool> isUserLoggedIn() async {
    try {
      return _dataSource.isUserLoggedIn();
    } catch (e) {
      print('Error checking user login status: $e');
      return false;
    }
  }

  @override
  Future<void> sendPasswordReset({required String email}) async {
    try {
      await _dataSource.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Error sending password reset: $e');
      rethrow;
    }
  }

  /// Map [AuthUser] to [UserEntity].
  ///
  /// Converts data layer auth user to domain entity for use in business logic.
  UserEntity _mapAuthUserToEntity(dynamic authUser) {
    return UserEntity(
      id: authUser.uid,
      email: authUser.email,
      name: authUser.displayName,
      photoUrl: authUser.photoUrl,
      createdAt: DateTime.now(),
    );
  }
}
