/// Lightweight wrapper for Firebase authenticated user data.
/// 
/// Used by [FirebaseAuthDataSource] to return consistent user information
/// across different authentication methods.
class AuthUser {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;

  const AuthUser({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
  });

  @override
  String toString() =>
      'AuthUser(uid: $uid, email: $email, displayName: $displayName, photoUrl: $photoUrl)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthUser &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          email == other.email &&
          displayName == other.displayName &&
          photoUrl == other.photoUrl;

  @override
  int get hashCode =>
      uid.hashCode ^
      email.hashCode ^
      displayName.hashCode ^
      photoUrl.hashCode;
}
