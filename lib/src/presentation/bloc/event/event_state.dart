import '../../../domain/entities/event_entity.dart';

/// Base class for all event-related states.
abstract class EventState {
  const EventState();
}

/// Initial state before any event has been loaded.
class EventInitial extends EventState {
  const EventInitial();

  @override
  String toString() => 'EventInitial()';
}

/// State while events are being loaded from Firestore.
class EventLoading extends EventState {
  const EventLoading();

  @override
  String toString() => 'EventLoading()';
}

/// State when events have been successfully loaded and streamed.
/// 
/// Contains the current list of events. This state is emitted whenever
/// the Firestore stream updates with new event data.
class EventsLoaded extends EventState {
  final List<EventEntity> events;

  const EventsLoaded({required this.events});

  @override
  String toString() => 'EventsLoaded(count: ${events.length})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventsLoaded &&
          runtimeType == other.runtimeType &&
          events == other.events;

  @override
  int get hashCode => events.hashCode;
}

/// State when an event operation (create/update/delete) completes successfully.
/// 
/// Indicates the operation succeeded. The updated event list is available
/// in the next [EventsLoaded] state from the stream.
class EventOperationSuccess extends EventState {
  final String message;

  const EventOperationSuccess({
    this.message = 'Operation completed successfully',
  });

  @override
  String toString() => 'EventOperationSuccess(message: $message)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventOperationSuccess &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

/// State when an event operation (create/update/delete) fails.
/// 
/// Contains error message to display to user. The event list remains
/// unchanged from the last [EventsLoaded] state.
class EventOperationFailure extends EventState {
  final String message;

  const EventOperationFailure({required this.message});

  @override
  String toString() => 'EventOperationFailure(message: $message)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventOperationFailure &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

/// State when an error occurs while loading events.
class EventLoadFailure extends EventState {
  final String message;

  const EventLoadFailure({required this.message});

  @override
  String toString() => 'EventLoadFailure(message: $message)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventLoadFailure &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}
