import 'package:flutter/material.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_state.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';
import '../pages/create_event_page.dart';
import '../pages/events_page.dart';
import '../widgets/main_app_shell.dart';

/// Route names for navigation.
class Routes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String events = '/events';
  static const String userEvents = '/user-events';
  static const String createEvent = '/create-event';
  static const String editEvent = '/edit-event';
  static const String eventDetails = '/event-details';
}

/// Application router using classic Navigator with named routes.
/// 
/// Provides route generation with authentication guards.
/// Protected routes redirect unauthenticated users to login.
class AppRouter {
  final AuthBloc authBloc;

  AppRouter({required this.authBloc});

  /// Generate route based on route name and arguments.
  /// 
  /// Returns appropriate page or redirects to login if route requires auth
  /// and user is not authenticated.
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    // Check if user is authenticated
    final isAuthenticated = authBloc.state is Authenticated;

    // Define which routes require authentication
    final protectedRoutes = [
      Routes.home,
      Routes.events,
      Routes.userEvents,
      Routes.createEvent,
      Routes.editEvent,
      Routes.eventDetails,
    ];

    // Redirect to login if accessing protected route while unauthenticated
    if (protectedRoutes.contains(settings.name) && !isAuthenticated) {
      return _buildRoute(
        settings,
        const LoginPage(),
      );
    }

    switch (settings.name) {
      case Routes.login:
        return _buildRoute(settings, const LoginPage());

      case Routes.register:
        return _buildRoute(settings, const RegisterPage());

      case Routes.home:
        return _buildRoute(
          settings,
          const MainAppShell(initialTab: 0),
        );

      case Routes.events:
        return _buildRoute(
          settings,
          const EventsPage(userEventsOnly: false),
        );

      case Routes.userEvents:
        return _buildRoute(
          settings,
          const EventsPage(userEventsOnly: true),
        );

      case Routes.createEvent:
        return _buildRoute(settings, const CreateEventPage());

      case Routes.editEvent:
        // Extract event ID from arguments
        final args = settings.arguments as Map<String, dynamic>?;
        final eventId = args?['eventId'] as String?;
        return _buildRoute(
          settings,
          CreateEventPage(eventId: eventId),
        );

      case Routes.eventDetails:
        // Extract event ID from arguments
        final args = settings.arguments as Map<String, dynamic>?;
        final eventId = args?['eventId'] as String?;
        return _buildRoute(
          settings,
          EventDetailsPage(eventId: eventId ?? ''),
        );

      default:
        return _buildRoute(
          settings,
          const Scaffold(
            body: Center(
              child: Text('Route not found: ${settings.name}'),
            ),
          ),
        );
    }
  }

  /// Build material page route with fade transition.
  MaterialPageRoute<dynamic> _buildRoute(
    RouteSettings settings,
    Widget page,
  ) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => page,
    );
  }
}

/// Placeholder for event details page.
class EventDetailsPage extends StatelessWidget {
  final String eventId;

  const EventDetailsPage({
    Key? key,
    required this.eventId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
      ),
      body: Center(
        child: Text('Event ID: $eventId'),
      ),
    );
  }
}
