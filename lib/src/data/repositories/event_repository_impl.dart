import '../../domain/entities/event_entity.dart';
import '../../domain/repositories/event_repository.dart';
import '../../core/utils/local_storage_service.dart';
import '../datasources/firestore_event_datasource.dart';
import '../models/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Concrete implementation of [EventRepository].
/// 
/// Coordinates between [FirestoreEventDataSource] and the domain layer.
/// Handles data transformation (model -> entity) and error management.
class EventRepositoryImpl implements EventRepository {
  final FirestoreEventDataSource _dataSource;
  final LocalStorageService _localStorageService;

  EventRepositoryImpl({
    required FirestoreEventDataSource dataSource,
    required LocalStorageService localStorageService,
  })  : _dataSource = dataSource,
        _localStorageService = localStorageService;

  @override
  Future<EventEntity> createEvent({required EventEntity event}) async {
    try {
      // Get current user ID from local storage
      final userId = _localStorageService.getUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Convert entity to model
      final eventModel = _mapEntityToModel(event);

      // Call data source with authenticated user
      final createdModel = await _dataSource.createEvent(
        event: eventModel,
        userId: userId,
      );

      // Map result back to entity
      return _mapModelToEntity(createdModel);
    } catch (e) {
      // Log error and rethrow with context
      print('Error creating event: $e');
      rethrow;
    }
  }

  @override
  Future<EventEntity> updateEvent({required EventEntity event}) async {
    try {
      final userId = _localStorageService.getUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final eventModel = _mapEntityToModel(event);
      final updatedModel = await _dataSource.updateEvent(
        event: eventModel,
        userId: userId,
      );

      return _mapModelToEntity(updatedModel);
    } catch (e) {
      print('Error updating event: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteEvent({required String eventId}) async {
    try {
      await _dataSource.deleteEvent(eventId: eventId);
    } catch (e) {
      print('Error deleting event: $e');
      rethrow;
    }
  }

  @override
  Future<EventEntity?> fetchEventById({required String eventId}) async {
    try {
      final model = await _dataSource.fetchEventById(eventId: eventId);
      return model != null ? _mapModelToEntity(model) : null;
    } catch (e) {
      print('Error fetching event by ID: $e');
      rethrow;
    }
  }

  @override
  Future<List<EventEntity>> fetchUserEvents({required String userId}) async {
    try {
      final models = await _dataSource.fetchUserEvents(
        userId: userId,
        pageSize: 20,
      );
      return models.map(_mapModelToEntity).toList();
    } catch (e) {
      print('Error fetching user events: $e');
      rethrow;
    }
  }

  @override
  Future<List<EventEntity>> fetchAllEvents() async {
    try {
      final models = await _dataSource.fetchAllEvents(pageSize: 20);
      return models.map(_mapModelToEntity).toList();
    } catch (e) {
      print('Error fetching all events: $e');
      rethrow;
    }
  }

  @override
  Stream<List<EventEntity>> streamEvents() {
    try {
      return _dataSource.streamAllEvents().map(
            (models) => models.map(_mapModelToEntity).toList(),
          );
    } catch (e) {
      print('Error streaming events: $e');
      rethrow;
    }
  }

  @override
  Stream<List<EventEntity>> streamUserEvents({required String userId}) {
    try {
      return _dataSource.streamUserEvents(userId: userId).map(
            (models) => models.map(_mapModelToEntity).toList(),
          );
    } catch (e) {
      print('Error streaming user events: $e');
      rethrow;
    }
  }

  /// Map [EventModel] to [EventEntity].
  /// 
  /// Converts data layer model to domain entity for use in business logic.
  EventEntity _mapModelToEntity(EventModel model) {
    return EventEntity(
      id: model.id,
      title: model.title,
      description: model.description,
      startTime: model.startTime,
      endTime: model.endTime,
      location: model.location,
      organizerId: model.uid,
      organizerName: model.organizerName,
      attendeeIds: model.attendeeIds,
      imageUrl: model.imageUrl,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  /// Map [EventEntity] to [EventModel].
  /// 
  /// Converts domain entity to data layer model for persistence.
  EventModel _mapEntityToModel(EventEntity entity) {
    return EventModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      startTime: entity.startTime,
      endTime: entity.endTime,
      location: entity.location,
      uid: entity.organizerId,
      organizerName: entity.organizerName,
      attendeeIds: entity.attendeeIds,
      imageUrl: entity.imageUrl,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
