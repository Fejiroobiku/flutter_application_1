import '../entities/event_entity.dart';
import '../repositories/event_repository.dart';

/// Use case for creating a new event.
/// 
/// Encapsulates the business logic for event creation and delegates
/// to the event repository for data persistence.
class CreateEventUseCase {
  final EventRepository repository;

  CreateEventUseCase(this.repository);

  /// Create a new event.
  /// 
  /// Takes [params] containing the event details and returns the created
  /// [EventEntity] with a generated ID.
  /// 
  /// Throws exception if creation fails.
  Future<EventEntity> call(CreateEventParams params) {
    return repository.createEvent(
      event: params.event,
    );
  }
}

/// Parameters for [CreateEventUseCase].
class CreateEventParams {
  final EventEntity event;

  CreateEventParams({required this.event});
}
