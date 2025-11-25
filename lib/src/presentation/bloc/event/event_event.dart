import '../../../domain/entities/event_entity.dart';

/// Base class for all event-related events.
abstract class EventEvent {
  const EventEvent();
}

/// Event to load all events or user's events with real-time streaming.
/// 
/// If [userId] is provided, streams only events created by that user.
/// Otherwise, streams all available events.
class LoadEvents extends EventEvent {
  final String? userId;

  const LoadEvents({this.userId});

  @override
  String toString() => 'LoadEvents(userId: $userId)';
}

/// Event to create a new event.
class CreateEventRequested extends EventEvent {
  final EventEntity event;

  const CreateEventRequested({required this.event});

  @override
  String toString() => 'CreateEventRequested(title: ${event.title})';
}

/// Event to update an existing event.
class UpdateEventRequested extends EventEvent {
  final EventEntity event;

  const UpdateEventRequested({required this.event});

  @override
  String toString() => 'UpdateEventRequested(id: ${event.id})';
}

/// Event to delete an event.
class DeleteEventRequested extends EventEvent {
  final String eventId;

  const DeleteEventRequested({required this.eventId});

  @override
  String toString() => 'DeleteEventRequested(eventId: $eventId)';
}

/// Event triggered when Firestore stream emits new event list.
/// 
/// Internal event used to emit loaded events to UI.
class EventsUpdated extends EventEvent {
  final List<EventEntity> events;

  const EventsUpdated({required this.events});

  @override
  String toString() => 'EventsUpdated(count: ${events.length})';
}
