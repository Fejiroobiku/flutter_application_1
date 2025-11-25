import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';
import '../services/storage_service.dart';

class EventRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageService storageService;

  EventRepository({required this.storageService});

  CollectionReference get _eventsCollection => _firestore.collection('events');

  /// Creates event. If imageBytes/file provided, upload first and set imageUrl.
  Future<Event> createEvent({
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required String ownerId,
    Uint8List? imageBytes, // use on web
    File? imageFile, // use on mobile
    String? filename,
  }) async {
    final createdAt = DateTime.now();
    // create doc first to have an id for storage path
    final docRef = await _eventsCollection.add({
      'title': title,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'ownerId': ownerId,
      'imageUrl': null,
    });

    String? imageUrl;
    if ((imageBytes != null || imageFile != null) && filename != null) {
      imageUrl = await storageService.uploadEventImage(
        eventId: docRef.id,
        filename: filename,
        bytes: imageBytes,
        file: imageFile,
      );
      await docRef.update({'imageUrl': imageUrl});
    }

    final snap = await docRef.get();
    return Event.fromDoc(snap);
  }

  Future<Event> updateEvent({
    required String eventId,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    Uint8List? imageBytes,
    File? imageFile,
    String? filename,
  }) async {
    final updateMap = <String, dynamic>{};
    if (title != null) updateMap['title'] = title;
    if (description != null) updateMap['description'] = description;
    if (startDate != null) updateMap['startDate'] = Timestamp.fromDate(startDate);
    if (endDate != null) updateMap['endDate'] = Timestamp.fromDate(endDate);

    final docRef = _eventsCollection.doc(eventId);

    if ((imageBytes != null || imageFile != null) && filename != null) {
      final imageUrl = await storageService.uploadEventImage(
        eventId: eventId,
        filename: filename,
        bytes: imageBytes,
        file: imageFile,
      );
      updateMap['imageUrl'] = imageUrl;
    }

    if (updateMap.isNotEmpty) await docRef.update(updateMap);

    final snap = await docRef.get();
    return Event.fromDoc(snap);
  }

  Future<void> deleteEvent(String eventId) async {
    final docRef = _eventsCollection.doc(eventId);
    await docRef.delete();
    // optional: delete storage folder if needed (not implemented here)
  }

  /// Stream of events ordered by createdAt desc
  Stream<List<Event>> watchEvents() {
    return _eventsCollection.orderBy('createdAt', descending: true).snapshots().map(
          (snap) => snap.docs.map((d) => Event.fromDoc(d)).toList(),
        );
  }
}
