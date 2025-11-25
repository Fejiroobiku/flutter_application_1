import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/app_colors.dart';
import '../bloc/event/event_bloc.dart';
import '../bloc/event/event_event.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_state.dart';
import '../pages/events_page.dart';
import '../pages/dashboard_page.dart';
import '../pages/profile_page.dart';
import 'core/di/injection.dart';
import 'presentation/app.dart';

Future<void> initializeApp() async {
  // Initialize dependency injection and other core services.
  await init();
}

void runEventEaseApp() {
  runApp(const EventEaseApp());
}

class EventEaseApp extends StatelessWidget {
  const EventEaseApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EventEase',
      theme: ThemeData(
        primaryColor: AppColors.emerald600,
        scaffoldBackgroundColor: AppColors.gray50,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      home: LoginPage(),
      routes: {
        '/home': (context) => MainAppShell(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/dashboard': (context) => MainAppShell(initialTab: 2),
        '/events': (context) => MainAppShell(initialTab: 1),
        '/create-event': (context) => CreateEventPage(),
      },
    );
  }
}
