import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../repositories/event_repository.dart';
import '../utils/snackbar_helper.dart';

abstract class EventState {}

class EventsLoading extends EventState {}

class EventsLoaded extends EventState {
  final List<Event> events;
  EventsLoaded(this.events);
}

class EventsError extends EventState {
  final String message;
  EventsError(this.message);
}

class EventBloc {
  final EventRepository repository;
  final StreamController<EventState> _stateController = StreamController.broadcast();
  StreamSubscription<List<Event>>? _eventsSub;

  EventBloc({required this.repository}) {
    _init();
  }

  Stream<EventState> get stream => _stateController.stream;

  void _init() {
    _stateController.add(EventsLoading());
    _eventsSub = repository.watchEvents().listen((events) {
      _stateController.add(EventsLoaded(events));
    }, onError: (e, st) {
      _stateController.add(EventsError(e.toString()));
    });
  }

  Future<void> createEvent({
    required BuildContext context,
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required String ownerId,
    Uint8List? imageBytes,
    File? imageFile,
    String? filename,
  }) async {
    try {
      await repository.createEvent(
        title: title,
        description: description,
        startDate: startDate,
        endDate: endDate,
        ownerId: ownerId,
        imageBytes: imageBytes,
        imageFile: imageFile,
        filename: filename,
      );
      SnackBarHelper.showSuccess(context, 'Event created');
      // events stream subscription will emit updated list automatically
    } catch (e) {
      SnackBarHelper.showError(context, 'Failed to create event: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> updateEvent({
    required BuildContext context,
    required String eventId,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    Uint8List? imageBytes,
    File? imageFile,
    String? filename,
  }) async {
    try {
      await repository.updateEvent(
        eventId: eventId,
        title: title,
        description: description,
        startDate: startDate,
        endDate: endDate,
        imageBytes: imageBytes,
        imageFile: imageFile,
        filename: filename,
      );
      SnackBarHelper.showSuccess(context, 'Event updated');
    } catch (e) {
      SnackBarHelper.showError(context, 'Failed to update event: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> deleteEvent({
    required BuildContext context,
    required String eventId,
  }) async {
    try {
      await repository.deleteEvent(eventId);
      SnackBarHelper.showSuccess(context, 'Event deleted');
    } catch (e) {
      SnackBarHelper.showError(context, 'Failed to delete event: ${e.toString()}');
      rethrow;
    }
  }

  void dispose() {
    _eventsSub?.cancel();
    _stateController.close();
  }
}
