import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../lib/src/usecases/create_event_usecase.dart';
import '../../lib/models/event_model.dart';
import '../../lib/repositories/event_repository.dart';

// Mock class
class MockEventRepository extends Mock implements EventRepository {}

void main() {
  late MockEventRepository mockRepo;
  late CreateEventUsecase usecase;

  setUpAll(() {
    // registerFallbackValue if repository methods require complex non-nullable objects
    // not needed for this test as we pass concrete values or nulls
  });

  setUp(() {
    mockRepo = MockEventRepository();
    usecase = CreateEventUsecase(repository: mockRepo);
  });

  test('CreateEventUsecase calls repository.createEvent and returns Event on success', () async {
    // arrange
    final title = 'Test Event';
    final description = 'Desc';
    final startDate = DateTime.utc(2025, 1, 1);
    final endDate = DateTime.utc(2025, 1, 2);
    final ownerId = 'owner123';

    final returnedEvent = Event(
      id: 'evt1',
      title: title,
      description: description,
      createdAt: DateTime.now(),
      startDate: startDate,
      endDate: endDate,
      ownerId: ownerId,
      imageUrl: null,
    );

    when(() => mockRepo.createEvent(
          title: title,
          description: description,
          startDate: startDate,
          endDate: endDate,
          ownerId: ownerId,
          imageBytes: null,
          imageFile: null,
          filename: null,
        )).thenAnswer((_) async => returnedEvent);

    // act
    final result = await usecase.execute(
      title: title,
      description: description,
      startDate: startDate,
      endDate: endDate,
      ownerId: ownerId,
      imageBytes: null,
      imageFile: null,
      filename: null,
    );

    // assert
    expect(result, equals(returnedEvent));
    verify(() => mockRepo.createEvent(
          title: title,
          description: description,
          startDate: startDate,
          endDate: endDate,
          ownerId: ownerId,
          imageBytes: null,
          imageFile: null,
          filename: null,
        )).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
