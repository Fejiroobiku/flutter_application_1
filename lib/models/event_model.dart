import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String? id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime startDate;
  final DateTime endDate;
  final String ownerId;
  final String? imageUrl;

  Event({
    this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.startDate,
    required this.endDate,
    required this.ownerId,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'ownerId': ownerId,
      'imageUrl': imageUrl,
    };
  }

  factory Event.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      ownerId: data['ownerId'] ?? '',
      imageUrl: data['imageUrl'] as String?,
    );
  }
}
