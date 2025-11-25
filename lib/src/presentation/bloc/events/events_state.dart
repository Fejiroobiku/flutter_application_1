import '../../../domain/entities/event_entity.dart';

abstract class EventsState {}

class EventsInitial extends EventsState {}

class EventsLoading extends EventsState {}

class EventsLoaded extends EventsState {
  final List<EventEntity> events;

  EventsLoaded(this.events);
}

class EventsFailure extends EventsState {
  final String message;

  EventsFailure(this.message);
}
