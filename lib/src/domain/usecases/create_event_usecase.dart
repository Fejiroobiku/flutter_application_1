import '../repositories/event_repository.dart';
import '../entities/event_entity.dart';

class CreateEventUseCase {
  final EventRepository repository;

  CreateEventUseCase(this.repository);

  Future<EventEntity> call(EventEntity event) {
    return repository.createEvent(event: event);
  }
}
