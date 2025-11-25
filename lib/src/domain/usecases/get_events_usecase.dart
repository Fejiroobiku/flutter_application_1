import '../repositories/event_repository.dart';
import '../entities/event_entity.dart';

class GetEventsUseCase {
  final EventRepository repository;

  GetEventsUseCase(this.repository);

  Future<List<EventEntity>> call() {
    return repository.fetchAllEvents();
  }
}
