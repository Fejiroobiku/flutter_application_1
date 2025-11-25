import '../../../domain/entities/event_entity.dart';

abstract class EventsEvent {}

class GetEventsEvent extends EventsEvent {}

class CreateEventEvent extends EventsEvent {
  final EventEntity event;

  CreateEventEvent(this.event);
}
