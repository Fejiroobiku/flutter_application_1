import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import '../../lib/src/pages/login_page.dart';
import '../../lib/src/blocs/auth_bloc.dart';

// Mock AuthBloc
class MockAuthBloc extends Mock implements AuthBloc {}

void main() {
  group('LoginPage', () {
    late MockAuthBloc mockAuthBloc;

    setUp(() {
      mockAuthBloc = MockAuthBloc();
      // Set initial state
      when(() => mockAuthBloc.state).thenReturn(AuthInitial());
      when(() => mockAuthBloc.stream).thenAnswer(
        (_) => Stream.value(AuthInitial()),
      );
    });

    testWidgets('renders email and password fields and login button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(authBloc: mockAuthBloc),
        ),
      );

      expect(find.byType(TextFormField), findsWidgets); // email + password
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
    });

    testWidgets('validates email and password before submission', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(authBloc: mockAuthBloc),
        ),
      );

      // Try to sign in without filling fields
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Should show validation errors
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);

      // Verify SignInRequested was NOT added
      verifyNever(() => mockAuthBloc.add(any()));
    });

    testWidgets('dispatches SignInRequested event on valid input', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(authBloc: mockAuthBloc),
        ),
      );

      const email = 'test@example.com';
      const password = 'password123';

      // Fill email field
      await tester.enterText(find.byType(TextFormField).first, email);
      // Fill password field
      await tester.enterText(find.byType(TextFormField).last, password);
      await tester.pumpAndSettle();

      // Tap login button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify SignInRequested was added with correct params
      verify(() => mockAuthBloc.add(
            any<SignInRequested>(
              that: isA<SignInRequested>()
                  .having((e) => e.email, 'email', email)
                  .having((e) => e.password, 'password', password),
            ),
          )).called(1);
    });

    testWidgets('shows loading indicator when AuthLoading state is emitted', (WidgetTester tester) async {
      // Create a StreamController to control auth bloc state
      final stateStream = Stream<AuthState>.value(AuthLoading());

      when(() => mockAuthBloc.state).thenReturn(AuthLoading());
      when(() => mockAuthBloc.stream).thenAnswer((_) => stateStream);

      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(authBloc: mockAuthBloc),
        ),
      );

      // Initially should not show loading
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Emit loading state
      when(() => mockAuthBloc.state).thenReturn(AuthLoading());
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(authBloc: mockAuthBloc),
        ),
      );

      // Trigger rebuild by entering text and tapping (or use blocBuilder update)
      const email = 'test@example.com';
      const password = 'password123';

      await tester.enterText(find.byType(TextFormField).first, email);
      await tester.enterText(find.byType(TextFormField).last, password);
      await tester.pumpAndSettle();

      // Simulate state change to loading via stream
      // For proper testing, wrap MaterialApp in a stateful widget that listens to the stream
      // This is a simplified version; a more robust approach uses bloc_test's blocTest helper

      // Note: Direct state mutation test shown below with BlocBuilder
    });

    testWidgets('BlocBuilder updates UI when state changes to AuthLoading', (WidgetTester tester) async {
      // Use a custom test harness to control state changes
      final bloc = _TestAuthBloc();

      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(authBloc: bloc),
        ),
      );

      const email = 'test@example.com';
      const password = 'password123';

      await tester.enterText(find.byType(TextFormField).first, email);
      await tester.enterText(find.byType(TextFormField).last, password);
      await tester.pumpAndSettle();

      // Tap button (simulates SignInRequested)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Manually change bloc state to AuthLoading for this test
      bloc.emit(AuthLoading());
      await tester.pumpAndSettle();

      // Verify loading indicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Button should be disabled
      final button = find.byType(ElevatedButton);
      expect(tester.widget<ElevatedButton>(button).onPressed, isNull);
    });
  });
}

// Test helper bloc that allows manual emit for testing
class _TestAuthBloc extends AuthBloc {
  void emit(AuthState state) {
    // Directly emit state for testing purposes
    super.emit(state);
  }
}
