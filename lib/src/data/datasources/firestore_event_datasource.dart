import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';

/// Data source for event operations using Firebase Firestore.
/// 
/// Handles all direct interactions with Firestore for event CRUD operations,
/// including real-time streaming and ordered queries.
class FirestoreEventDataSource {
  final FirebaseFirestore _firestore;
  static const String _collectionPath = 'events';
  static const int _pageSize = 20;

  FirestoreEventDataSource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  /// Create a new event in Firestore.
  /// 
  /// Stores the event with the provided [userId] as the owner/organizer.
  /// Firestore generates the document ID automatically.
  /// Returns the model with the generated event ID.
  Future<EventModel> createEvent({
    required EventModel event,
    required String userId,
  }) async {
    try {
      final docRef = _firestore.collection(_collectionPath).doc();
      
      final eventData = event.toJson();
      eventData['uid'] = userId; // Store organizer ID
      eventData['createdAt'] = FieldValue.serverTimestamp();
      eventData['updatedAt'] = FieldValue.serverTimestamp();

      await docRef.set(eventData);

      return event.copyWith(id: docRef.id);
    } catch (e) {
      throw _handleFirestoreException(e);
    }
  }

  /// Update an existing event in Firestore.
  /// 
  /// Updates the event document with the provided [event] data.
  /// Only updates fields that have changed.
  /// Returns the updated model.
  Future<EventModel> updateEvent({
    required EventModel event,
    required String userId,
  }) async {
    try {
      final eventData = event.toJson();
      eventData['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore
          .collection(_collectionPath)
          .doc(event.id)
          .update(eventData);

      return event;
    } catch (e) {
      throw _handleFirestoreException(e);
    }
  }

  /// Delete an event from Firestore.
  /// 
  /// Removes the event document with the specified [eventId].
  Future<void> deleteEvent({required String eventId}) async {
    try {
      await _firestore.collection(_collectionPath).doc(eventId).delete();
    } catch (e) {
      throw _handleFirestoreException(e);
    }
  }

  /// Fetch a single event by ID.
  /// 
  /// Retrieves the event document from Firestore.
  /// Returns null if event doesn't exist.
  Future<EventModel?> fetchEventById({required String eventId}) async {
    try {
      final snapshot =
          await _firestore.collection(_collectionPath).doc(eventId).get();

      if (!snapshot.exists) return null;

      return EventModel.fromJson(snapshot.data()!);
    } catch (e) {
      throw _handleFirestoreException(e);
    }
  }

  /// Fetch all events ordered by creation date (newest first).
  /// 
  /// Retrieves events in descending order by [createdAt] timestamp.
  /// Supports pagination with optional [lastDocument] and [pageSize].
  Future<List<EventModel>> fetchAllEvents({
    DocumentSnapshot? lastDocument,
    int pageSize = _pageSize,
  }) async {
    try {
      Query query = _firestore
          .collection(_collectionPath)
          .orderBy('createdAt', descending: true)
          .limit(pageSize);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final snapshot = await query.get();

      return snapshot.docs
          .map((doc) => EventModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw _handleFirestoreException(e);
    }
  }

  /// Fetch events created by a specific user with pagination.
  /// 
  /// Retrieves events organized by [userId], ordered by creation date (newest first).
  /// Supports pagination with optional [lastDocument] and [pageSize].
  /// 
  /// Returns a list of [EventModel] objects. Empty list if user has no events.
  Future<List<EventModel>> fetchUserEvents({
    required String userId,
    DocumentSnapshot? lastDocument,
    int pageSize = _pageSize,
  }) async {
    try {
      Query query = _firestore
          .collection(_collectionPath)
          .where('uid', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(pageSize);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final snapshot = await query.get();

      return snapshot.docs
          .map((doc) => EventModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw _handleFirestoreException(e);
    }
  }

  /// Stream all events ordered by creation date (real-time updates).
  /// 
  /// Returns a stream that emits event list updates whenever data changes.
  /// Events are ordered by creation date in descending order.
  /// 
  /// Example:
  /// ```dart
  /// dataSource.streamAllEvents().listen((events) {
  ///   print('Events updated: ${events.length}');
  /// });
  /// ```
  Stream<List<EventModel>> streamAllEvents() {
    try {
      return _firestore
          .collection(_collectionPath)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) =>
                  EventModel.fromJson(doc.data() as Map<String, dynamic>))
              .toList());
    } catch (e) {
      throw _handleFirestoreException(e);
    }
  }

  /// Stream events created by a specific user (real-time updates).
  /// 
  /// Returns a stream that emits updates for events organized by [userId].
  /// Events are ordered by creation date in descending order.
  /// 
  /// Example:
  /// ```dart
  /// dataSource.streamUserEvents(userId: 'user123').listen((events) {
  ///   print('User events updated: ${events.length}');
  /// });
  /// ```
  Stream<List<EventModel>> streamUserEvents({required String userId}) {
    try {
      return _firestore
          .collection(_collectionPath)
          .where('uid', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) =>
                  EventModel.fromJson(doc.data() as Map<String, dynamic>))
              .toList());
    } catch (e) {
      throw _handleFirestoreException(e);
    }
  }

  /// Handle Firestore exceptions and convert to meaningful error messages.
  Exception _handleFirestoreException(dynamic e) {
    if (e is FirebaseException) {
      switch (e.code) {
        case 'permission-denied':
          return Exception('Permission denied to perform this operation');
        case 'not-found':
          return Exception('Document not found');
        case 'already-exists':
          return Exception('Document already exists');
        case 'unavailable':
          return Exception('Service temporarily unavailable');
        default:
          return Exception('Firestore error: ${e.message}');
      }
    }
    return Exception('Unexpected error: $e');
  }
}
