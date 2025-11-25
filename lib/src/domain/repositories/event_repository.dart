import '../entities/event_entity.dart';

/// Abstract repository for event operations.
/// 
/// Defines contracts for all event-related use cases including CRUD operations
/// and real-time event streaming.
abstract class EventRepository {
  /// Create a new event.
  /// 
  /// Takes an [EventEntity] and persists it to the data source.
  /// Returns the created event with generated ID.
  /// Throws exception if creation fails.
  Future<EventEntity> createEvent({required EventEntity event});

  /// Update an existing event.
  /// 
  /// Takes an [EventEntity] with existing ID and updates it in the data source.
  /// Returns the updated [EventEntity].
  /// Throws exception if event not found or update fails.
  Future<EventEntity> updateEvent({required EventEntity event});

  /// Delete an event by ID.
  /// 
  /// Removes the event from the data source.
  /// Throws exception if event not found or deletion fails.
  Future<void> deleteEvent({required String eventId});

  /// Fetch a single event by ID.
  /// 
  /// Retrieves the event details for the specified ID.
  /// Returns the [EventEntity] if found.
  /// Returns null if event doesn't exist.
  /// Throws exception on data source failure.
  Future<EventEntity?> fetchEventById({required String eventId});

  /// Fetch all events created by a specific user.
  /// 
  /// Retrieves a list of events organized by the user with [userId].
  /// Returns empty list if user has no events.
  /// Throws exception on data source failure.
  Future<List<EventEntity>> fetchUserEvents({required String userId});

  /// Fetch all events (with optional filtering).
  /// 
  /// Retrieves all available events from the data source.
  /// Returns empty list if no events exist.
  /// Throws exception on data source failure.
  Future<List<EventEntity>> fetchAllEvents();

  /// Stream real-time event updates.
  /// 
  /// Returns a [Stream] of event lists that emits updates whenever
  /// events change in the data source. Useful for real-time UI updates.
  /// 
  /// Example:
  /// ```dart
  /// repository.streamEvents().listen((events) {
  ///   // Update UI with new events
  /// });
  /// ```
  Stream<List<EventEntity>> streamEvents();

  /// Stream real-time updates for user's events.
  /// 
  /// Returns a [Stream] of event lists for events organized by [userId].
  /// Emits updates whenever user's events change.
  Stream<List<EventEntity>> streamUserEvents({required String userId});
}
