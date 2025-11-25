import 'package:here_bro/src/domain/entities/event_entity.dart';

/// Data model for events persisted in Firestore.
/// 
/// Handles JSON serialization/deserialization and conversion to domain entity.
/// The `uid` field represents the event organizer's user ID.
class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final String uid; // Organizer user ID
  final String organizerName;
  final List<String> attendeeIds;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.uid,
    required this.organizerName,
    required this.attendeeIds,
    this.imageUrl,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create [EventModel] from JSON (Firestore document).
  /// 
  /// Handles timestamp deserialization and defaults for optional fields.
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      startTime: _parseTimestamp(json['startTime']),
      endTime: _parseTimestamp(json['endTime']),
      location: json['location'] ?? '',
      uid: json['uid'] ?? '',
      organizerName: json['organizerName'] ?? '',
      attendeeIds: List<String>.from(json['attendeeIds'] ?? []),
      imageUrl: json['imageUrl'],
      createdAt: _parseTimestamp(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? _parseTimestamp(json['updatedAt'])
          : null,
    );
  }

  /// Convert [EventModel] to JSON for Firestore storage.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime,
      'endTime': endTime,
      'location': location,
      'uid': uid,
      'organizerName': organizerName,
      'attendeeIds': attendeeIds,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Convert [EventModel] to domain [EventEntity].
  /// 
  /// Maps all fields from the data model to the domain entity.
  EventEntity toEntity() {
    return EventEntity(
      id: id,
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      location: location,
      organizerId: uid,
      organizerName: organizerName,
      attendeeIds: attendeeIds,
      imageUrl: imageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create a copy of [EventModel] with optional field overrides.
  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    String? uid,
    String? organizerName,
    List<String>? attendeeIds,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      uid: uid ?? this.uid,
      organizerName: organizerName ?? this.organizerName,
      attendeeIds: attendeeIds ?? this.attendeeIds,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          startTime == other.startTime &&
          endTime == other.endTime &&
          location == other.location &&
          uid == other.uid &&
          organizerName == other.organizerName &&
          attendeeIds == other.attendeeIds &&
          imageUrl == other.imageUrl &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      startTime.hashCode ^
      endTime.hashCode ^
      location.hashCode ^
      uid.hashCode ^
      organizerName.hashCode ^
      attendeeIds.hashCode ^
      imageUrl.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;

  @override
  String toString() =>
      'EventModel(id: $id, title: $title, startTime: $startTime, endTime: $endTime, uid: $uid)';

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