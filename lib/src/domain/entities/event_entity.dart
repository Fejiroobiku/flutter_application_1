class EventEntity {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final String organizerId;
  final String organizerName;
  final List<String> attendeeIds;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const EventEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.organizerId,
    required this.organizerName,
    required this.attendeeIds,
    this.imageUrl,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          startTime == other.startTime &&
          endTime == other.endTime &&
          location == other.location &&
          organizerId == other.organizerId &&
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
      organizerId.hashCode ^
      organizerName.hashCode ^
      attendeeIds.hashCode ^
      imageUrl.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;

  @override
  String toString() =>
      'EventEntity(id: $id, title: $title, description: $description, startTime: $startTime, endTime: $endTime, location: $location, organizerId: $organizerId, organizerName: $organizerName, attendeeIds: $attendeeIds, imageUrl: $imageUrl, createdAt: $createdAt, updatedAt: $updatedAt)';

  EventEntity copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    String? organizerId,
    String? organizerName,
    List<String>? attendeeIds,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EventEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      organizerId: organizerId ?? this.organizerId,
      organizerName: organizerName ?? this.organizerName,
      attendeeIds: attendeeIds ?? this.attendeeIds,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
