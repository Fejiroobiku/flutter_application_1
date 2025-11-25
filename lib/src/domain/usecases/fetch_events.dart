import '../entities/event_entity.dart';
import '../repositories/event_repository.dart';

/// Use case for fetching events.
/// 
/// Encapsulates the business logic for retrieving events with optional
/// user filtering and delegates to the event repository for data access.
class FetchEventsUseCase {
  final EventRepository repository;

  FetchEventsUseCase(this.repository);

  /// Fetch events based on parameters.
  /// 
  /// If [params.userId] is provided, fetches only events created by that user.
  /// Otherwise, fetches all available events.
  /// 
  /// Returns a list of [EventEntity] objects.
  /// Throws exception if fetching fails.
  Future<List<EventEntity>> call(FetchEventsParams params) {
    if (params.userId != null) {
      return repository.fetchUserEvents(userId: params.userId!);
    }
    return repository.fetchAllEvents();
  }
}

/// Parameters for [FetchEventsUseCase].
class FetchEventsParams {
  /// Optional user ID to filter events by organizer.
  final String? userId;

  FetchEventsParams({this.userId});
}
