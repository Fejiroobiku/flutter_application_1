import '../../../domain/entities/user_entity.dart';

/// Base class for all profile-related states.
abstract class ProfileState {
  const ProfileState();
}

/// Initial state before profile has been loaded.
class ProfileInitial extends ProfileState {
  const ProfileInitial();

  @override
  String toString() => 'ProfileInitial()';
}

/// State while profile is being loaded or updated.
class ProfileLoading extends ProfileState {
  const ProfileLoading();

  @override
  String toString() => 'ProfileLoading()';
}

/// State when profile has been successfully loaded.
/// 
/// Contains the user profile information.
class ProfileLoaded extends ProfileState {
  final UserEntity user;

  const ProfileLoaded(this.user);

  @override
  String toString() => 'ProfileLoaded(user: ${user.name})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileLoaded &&
          runtimeType == other.runtimeType &&
          user == other.user;

  @override
  int get hashCode => user.hashCode;
}

/// State when an error occurs while loading or updating profile.
class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  String toString() => 'ProfileError(message: $message)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}
