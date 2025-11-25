import '../../domain/entities/user_entity.dart';

/// Data model for users persisted in Firestore.
///
/// Handles JSON serialization/deserialization and conversion to domain entity.
/// Maps between API responses/Firestore documents and domain layer.
class UserModel {
  final String id;
  final String email;
  final String name;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create [UserModel] from JSON (Firestore document).
  ///
  /// Handles timestamp deserialization and defaults for optional fields.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['uid'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      photoUrl: json['photoUrl'],
      createdAt: _parseTimestamp(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? _parseTimestamp(json['updatedAt'])
          : null,
    );
  }

  /// Convert [UserModel] to JSON for Firestore storage.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': id, // Firestore uses 'uid' as field name
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Convert [UserModel] to domain [UserEntity].
  ///
  /// Maps all fields from the data model to the domain entity.
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      name: name,
      photoUrl: photoUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create a copy of [UserModel] with optional field overrides.
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          name == other.name &&
          photoUrl == other.photoUrl &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      email.hashCode ^
      name.hashCode ^
      photoUrl.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;

  @override
  String toString() =>
      'UserModel(id: $id, email: $email, name: $name, createdAt: $createdAt)';

  /// Parse timestamp from Firestore (Timestamp or DateTime).
  static DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp == null) return DateTime.now();
    if (timestamp is DateTime) return timestamp;
    if (timestamp.runtimeType.toString().contains('Timestamp')) {
      // Handle Firestore Timestamp type
      return (timestamp as dynamic).toDate() as DateTime;
    }
    return DateTime.now();
  }
}