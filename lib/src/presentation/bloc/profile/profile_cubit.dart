import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'profile_state.dart';

/// Cubit for managing user profile state.
/// 
/// Handles loading and updating user profile information.
/// Uses AuthRepository for user data operations.
/// 
/// State transitions:
/// - ProfileInitial -> ProfileLoading -> (ProfileLoaded | ProfileError)
/// - ProfileLoading -> ProfileLoading -> ProfileLoaded (on update success)
/// - ProfileLoading -> ProfileError (on failure)
class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepository _authRepository;

  ProfileCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const ProfileInitial());

  /// Load current user profile.
  /// 
  /// Fetches the authenticated user's profile information from repository.
  /// Emits ProfileLoading during fetch, then ProfileLoaded on success
  /// or ProfileError on failure.
  Future<void> loadProfile() async {
    emit(const ProfileLoading());

    try {
      final user = await _authRepository.getCurrentUser();

      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(const ProfileError(
          message: 'User profile not found',
        ));
      }
    } catch (e) {
      emit(ProfileError(
        message: _extractErrorMessage(e),
      ));
    }
  }

  /// Update user profile information.
  /// 
  /// Updates user details in the repository. Currently supports
  /// updating via auth repository. Emits ProfileLoading during update,
  /// then ProfileLoaded with updated user on success or ProfileError on failure.
  /// 
  /// Note: Full update functionality would require additional repository methods
  /// for updating individual user fields (name, photo, etc).
  Future<void> updateProfile({
    String? name,
    String? photoUrl,
  }) async {
    emit(const ProfileLoading());

    try {
      final currentUser = await _authRepository.getCurrentUser();

      if (currentUser != null) {
        // Create updated user entity
        final updatedUser = currentUser.copyWith(
          name: name ?? currentUser.name,
          photoUrl: photoUrl ?? currentUser.photoUrl,
        );

        // TODO: Call update method from AuthRepository when available
        // For now, emit the updated state
        emit(ProfileLoaded(updatedUser));
      } else {
        emit(const ProfileError(
          message: 'User not found',
        ));
      }
    } catch (e) {
      emit(ProfileError(
        message: _extractErrorMessage(e),
      ));
    }
  }

  /// Refresh user profile from server.
  /// 
  /// Re-fetches the current user profile, useful for syncing
  /// with server updates.
  Future<void> refreshProfile() async {
    emit(const ProfileLoading());

    try {
      final user = await _authRepository.getCurrentUser();

      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(const ProfileError(
          message: 'User profile not found',
        ));
      }
    } catch (e) {
      emit(ProfileError(
        message: _extractErrorMessage(e),
      ));
    }
  }

  /// Extract user-friendly error message from exception.
  String _extractErrorMessage(dynamic error) {
    if (error is Exception) {
      final message = error.toString();
      if (message.startsWith('Exception: ')) {
        return message.replaceFirst('Exception: ', '');
      }
      return message;
    }
    return 'An unexpected error occurred';
  }
}
