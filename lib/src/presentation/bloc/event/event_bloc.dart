import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/event_repository.dart';
import '../../../core/utils/local_storage_service.dart';
import 'event_event.dart';
import 'event_state.dart';

/// Business Logic Component (BLoC) for event management.
/// 
/// Manages event state and coordinates with the EventRepository.
/// Listens to user events (load, create, update, delete) and Firestore streams.
/// Provides real-time event updates via Firestore snapshots.
/// 
/// State transitions:
/// - LoadEvents -> EventLoading -> (EventsLoaded | EventLoadFailure)
/// - EventsLoaded -> EventsLoaded (on stream update)
/// - CreateEventRequested -> EventOperationSuccess/EventOperationFailure
/// - UpdateEventRequested -> EventOperationSuccess/EventOperationFailure
/// - DeleteEventRequested -> EventOperationSuccess/EventOperationFailure
class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository _eventRepository;
  final LocalStorageService _localStorageService;

  StreamSubscription? _eventStreamSubscription;

  EventBloc({
    required EventRepository eventRepository,
    required LocalStorageService localStorageService,
  })  : _eventRepository = eventRepository,
        _localStorageService = localStorageService,
        super(const EventInitial()) {
    // Register event handlers
    on<LoadEvents>(_onLoadEvents);
    on<EventsUpdated>(_onEventsUpdated);
    on<CreateEventRequested>(_onCreateEventRequested);
    on<UpdateEventRequested>(_onUpdateEventRequested);
    on<DeleteEventRequested>(_onDeleteEventRequested);
  }

  /// Handle load events request with real-time streaming.
  /// 
  /// Sets up Firestore stream subscription. If [userId] is provided,
  /// streams only user's events; otherwise streams all events.
  /// Emits EventsLoaded on each stream update.
  Future<void> _onLoadEvents(
    LoadEvents event,
    Emitter<EventState> emit,
  ) async {
    emit(const EventLoading());

    try {
      // Cancel previous subscription if exists
      await _eventStreamSubscription?.cancel();

      // Subscribe to appropriate stream based on userId
      if (event.userId != null) {
        _eventStreamSubscription = _eventRepository
            .streamUserEvents(userId: event.userId!)
            .listen(
              (events) {
                add(EventsUpdated(events: events));
              },
              onError: (error) {
                emit(EventLoadFailure(
                  message: _extractErrorMessage(error),
                ));
              },
            );
      } else {
        _eventStreamSubscription = _eventRepository.streamEvents().listen(
              (events) {
                add(EventsUpdated(events: events));
              },
              onError: (error) {
                emit(EventLoadFailure(
                  message: _extractErrorMessage(error),
                ));
              },
            );
      }
    } catch (e) {
      emit(EventLoadFailure(
        message: _extractErrorMessage(e),
      ));
    }
  }

  /// Handle events updated from Firestore stream.
  /// 
  /// Triggered internally when stream emits new event list.
  /// Emits EventsLoaded state with updated event list.
  Future<void> _onEventsUpdated(
    EventsUpdated event,
    Emitter<EventState> emit,
  ) async {
    emit(EventsLoaded(events: event.events));
  }

  /// Handle create event request.
  /// 
  /// Creates new event via repository. Emits success state on completion.
  /// Real-time update will be received via Firestore stream subscription.
  Future<void> _onCreateEventRequested(
    CreateEventRequested event,
    Emitter<EventState> emit,
  ) async {
    try {
      await _eventRepository.createEvent(event: event.event);

      emit(const EventOperationSuccess(
        message: 'Event created successfully',
      ));
    } catch (e) {
      emit(EventOperationFailure(
        message: _extractErrorMessage(e),
      ));
    }
  }

  /// Handle update event request.
  /// 
  /// Updates existing event via repository. Emits success state on completion.
  /// Real-time update will be received via Firestore stream subscription.
  Future<void> _onUpdateEventRequested(
    UpdateEventRequested event,
    Emitter<EventState> emit,
  ) async {
    try {
      await _eventRepository.updateEvent(event: event.event);

      emit(const EventOperationSuccess(
        message: 'Event updated successfully',
      ));
    } catch (e) {
      emit(EventOperationFailure(
        message: _extractErrorMessage(e),
      ));
    }
  }

  /// Handle delete event request.
  /// 
  /// Deletes event via repository. Emits success state on completion.
  /// Real-time update will be received via Firestore stream subscription.
  Future<void> _onDeleteEventRequested(
    DeleteEventRequested event,
    Emitter<EventState> emit,
  ) async {
    try {
      await _eventRepository.deleteEvent(eventId: event.eventId);

      emit(const EventOperationSuccess(
        message: 'Event deleted successfully',
      ));
    } catch (e) {
      emit(EventOperationFailure(
        message: _extractErrorMessage(e),
      ));
    }
  }

  /// Extract user-friendly error message from exception.
  String _extractErrorMessage(dynamic error) {
    if (error is Exception) {
      final message = error.toString();
      if (message.startsWith('Exception: ')) {
        return message.replaceFirst('Exception: ', '');
      }
      return message;
    }
    return 'An unexpected error occurred';
  }

  /// Clean up stream subscription on BLoC close.
  @override
  Future<void> close() {
    _eventStreamSubscription?.cancel();
    return super.close();
  }
}
