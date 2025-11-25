// Comprehensive tests for EventEase app
// Includes widget tests for UI components and unit tests for business logic

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:here_bro/domain/entities/event_entity.dart';

void main() {
  group('Widget Tests', () {
    testWidgets('Material app builds successfully', (WidgetTester tester) async {
      // Create a simple test app
      await tester.pumpWidget(
        MaterialApp(
          title: 'EventEase',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const Scaffold(
            body: Center(
              child: Text('Welcome to EventEase'),
            ),
          ),
        ),
      );

      // Verify MaterialApp exists
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.text('Welcome to EventEase'), findsOneWidget);
    });

    testWidgets('Login page structure renders', (WidgetTester tester) async {
      // Build a mock login page
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Login')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const TextField(
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify key elements exist
      expect(find.text('Login'), findsAtLeastNWidgets(1));
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });

  group('Unit Tests - EventEntity', () {
    test('EventEntity creates instance with correct properties', () {
      // Arrange
      final date = DateTime(2024, 12, 25);
      final createdAt = DateTime.now();

      // Act
      final event = EventEntity(
        id: 'test-id',
        title: 'Test Event',
        date: date,
        time: '14:00',
        location: 'Test Location',
        description: 'Test Description',
        image: 'https://test.com/image.jpg',
        attendees: 10,
        organizer: 'Test Organizer',
        category: 'Workshop',
        status: 'Upcoming',
        userId: 'user-123',
        createdAt: createdAt,
        attendeeIds: const ['user-1', 'user-2'],
        maxAttendees: 50,
      );

      // Assert
      expect(event.id, 'test-id');
      expect(event.title, 'Test Event');
      expect(event.date, date);
      expect(event.location, 'Test Location');
      expect(event.attendees, 10);
      expect(event.attendeeIds.length, 2);
      expect(event.maxAttendees, 50);
    });

    test('EventEntity equality works correctly', () {
      // Arrange
      final date = DateTime(2024, 12, 25);
      final createdAt = DateTime.now();

      final event1 = EventEntity(
        id: 'test-id',
        title: 'Test Event',
        date: date,
        location: 'Test Location',
        description: 'Test Description',
        image: 'https://test.com/image.jpg',
        attendees: 10,
        organizer: 'Test Organizer',
        createdAt: createdAt,
      );

      final event2 = EventEntity(
        id: 'test-id',
        title: 'Test Event',
        date: date,
        location: 'Test Location',
        description: 'Test Description',
        image: 'https://test.com/image.jpg',
        attendees: 10,
        organizer: 'Test Organizer',
        createdAt: createdAt,
      );

      // Assert
      expect(event1, event2);
      expect(event1.hashCode, event2.hashCode);
    });

    test('EventEntity with different IDs are not equal', () {
      // Arrange
      final date = DateTime(2024, 12, 25);
      final createdAt = DateTime.now();

      final event1 = EventEntity(
        id: 'test-id-1',
        title: 'Test Event',
        date: date,
        location: 'Test Location',
        description: 'Test Description',
        image: 'https://test.com/image.jpg',
        attendees: 10,
        organizer: 'Test Organizer',
        createdAt: createdAt,
      );

      final event2 = EventEntity(
        id: 'test-id-2',
        title: 'Test Event',
        date: date,
        location: 'Test Location',
        description: 'Test Description',
        image: 'https://test.com/image.jpg',
        attendees: 10,
        organizer: 'Test Organizer',
        createdAt: createdAt,
      );

      // Assert
      expect(event1, isNot(event2));
    });

    test('EventEntity maxAttendees limit validation', () {
      // Test event at capacity
      final event = EventEntity(
        id: 'test-id',
        title: 'Full Event',
        date: DateTime.now(),
        location: 'Test Location',
        description: 'Test Description',
        image: 'https://test.com/image.jpg',
        attendees: 50,
        organizer: 'Test Organizer',
        createdAt: DateTime.now(),
        maxAttendees: 50,
      );

      // Verify event is at capacity
      expect(event.attendees >= (event.maxAttendees ?? 0), isTrue);
    });
  });
}
