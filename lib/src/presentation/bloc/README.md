# BLoC

This directory contains BLoC classes for managing application state and business logic.

## Responsibilities
- Manage application state
- Handle business logic
- Convert user events to states
- Communicate between UI and domain layer
- Provide reactive state updates to UI

## Structure
Typically organized by feature:
- `feature_bloc.dart` - Main BLoC class
- `feature_event.dart` - Events (user actions)
- `feature_state.dart` - States (UI representations)
