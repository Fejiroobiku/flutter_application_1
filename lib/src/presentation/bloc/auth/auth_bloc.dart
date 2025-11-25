import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Business Logic Component (BLoC) for authentication.
///
/// Manages authentication state and coordinates with the AuthRepository.
/// Listens to user events (sign-in, sign-up, sign-out) and emits appropriate states.
///
/// State transitions:
/// - AppStarted -> Authenticating -> (Authenticated | Unauthenticated)
/// - SignInRequested -> Authenticating -> (Authenticated | AuthError)
/// - SignUpRequested -> Authenticating -> (Authenticated | AuthError)
/// - GoogleSignInRequested -> Authenticating -> (Authenticated | AuthError)
/// - SignOutRequested -> Authenticating -> Unauthenticated
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthInitial()) {
    // Register event handlers
    on<AppStarted>(_onAppStarted);
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
  }

  /// Handle app startup and check current authentication state.
  ///
  /// Checks if user is already logged in and emits appropriate state.
  /// Used to restore user session on app launch.
  Future<void> _onAppStarted(
    AppStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const Authenticating());

    try {
      final isLoggedIn = await _authRepository.isUserLoggedIn();

      if (isLoggedIn) {
        final user = await _authRepository.getCurrentUser();
        if (user != null) {
          emit(Authenticated(user));
          return;
        }
      }

      emit(const Unauthenticated());
    } catch (e) {
      emit(AuthError(_extractErrorMessage(e)));
    }
  }

  /// Handle sign in with email and password.
  ///
  /// Validates input, authenticates with repository, and emits appropriate state.
  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const Authenticating());

    try {
      // Validate input
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(const AuthError('Email and password are required'));
        return;
      }

      // Attempt sign in
      final user = await _authRepository.signInWithEmail(
        email: event.email,
        password: event.password,
      );

      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(_extractErrorMessage(e)));
    }
  }

  /// Handle sign up with email and password.
  ///
  /// Validates input, creates account, and emits appropriate state.
  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const Authenticating());

    try {
      // Validate input
      if (event.email.isEmpty ||
          event.password.isEmpty ||
          event.name.isEmpty) {
        emit(const AuthError('All fields are required'));
        return;
      }

      if (event.password.length < 6) {
        emit(const AuthError('Password must be at least 6 characters'));
        return;
      }

      // Attempt registration
      final user = await _authRepository.registerWithEmail(
        email: event.email,
        password: event.password,
        name: event.name,
      );

      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(_extractErrorMessage(e)));
    }
  }

  /// Handle sign in with Google.
  ///
  /// Triggers Google OAuth flow and emits appropriate state.
  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const Authenticating());

    try {
      final user = await _authRepository.signInWithGoogle();
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(_extractErrorMessage(e)));
    }
  }

  /// Handle sign out.
  ///
  /// Clears user session and emits unauthenticated state.
  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const Authenticating());

    try {
      await _authRepository.signOut();
      emit(const Unauthenticated());
    } catch (e) {
      emit(AuthError(_extractErrorMessage(e)));
    }
  }

  /// Extract user-friendly error message from exception.
  ///
  /// Converts exception to readable string for UI display.
  String _extractErrorMessage(dynamic error) {
    if (error is Exception) {
      final message = error.toString();
      // Remove "Exception: " prefix if present
      if (message.startsWith('Exception: ')) {
        return message.replaceFirst('Exception: ', '');
      }
      return message;
    }
    return 'An unexpected error occurred';
  }
}
