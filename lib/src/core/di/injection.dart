import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/local_storage_service.dart';
import '../../data/datasources/auth_datasource.dart';
import '../../data/datasources/firebase_auth_datasource.dart';
import '../../data/datasources/event_datasource.dart';
import '../../data/datasources/firestore_event_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/event_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/event_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/create_event_usecase.dart';
import '../../domain/usecases/get_events_usecase.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/bloc/events/events_bloc.dart';
import '../../presentation/bloc/profile/profile_bloc.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // Core Services
  await _registerCoreServices();
  
  // Data Sources
  _registerDataSources();
  
  // Repositories
  _registerRepositories();
  
  // Use Cases
  _registerUseCases();
  
  // BLoCs & Cubits
  _registerBLoCs();
}

/// Register Firebase and local storage services
Future<void> _registerCoreServices() async {
  // Firebase Auth
  getIt.registerSingleton<FirebaseAuth>(
    FirebaseAuth.instance,
  );

  // Firebase Firestore
  getIt.registerSingleton<FirebaseFirestore>(
    FirebaseFirestore.instance,
  );

  // Local Storage Service
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  getIt.registerSingleton<LocalStorageService>(
    LocalStorageService(getIt<SharedPreferences>()),
  );
}

/// Register data sources
void _registerDataSources() {
  getIt.registerSingleton<AuthDataSource>(
    // Deprecated generic auth datasource kept for compatibility.
    // Main app uses FirebaseAuthDataSource registered below.
    AuthDataSource(
      firebaseAuth: getIt<FirebaseAuth>(),
      firestore: getIt<FirebaseFirestore>(),
    ),
  );

  // Register GoogleSignIn used by Firebase auth datasource
  getIt.registerSingleton<GoogleSignIn>(
    GoogleSignIn(),
  );

  // Register Firebase-specific data sources expected by repository implementations
  getIt.registerSingleton<FirebaseAuthDataSource>(
    FirebaseAuthDataSource(
      firebaseAuth: getIt<FirebaseAuth>(),
      googleSignIn: getIt<GoogleSignIn>(),
    ),
  );

  getIt.registerSingleton<FirestoreEventDataSource>(
    FirestoreEventDataSource(
      firestore: getIt<FirebaseFirestore>(),
    ),
  );
}

/// Register repositories
void _registerRepositories() {
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      dataSource: getIt<FirebaseAuthDataSource>(),
      localStorageService: getIt<LocalStorageService>(),
    ),
  );

  getIt.registerSingleton<EventRepository>(
    EventRepositoryImpl(
      dataSource: getIt<FirestoreEventDataSource>(),
      localStorageService: getIt<LocalStorageService>(),
    ),
  );
}

/// Register use cases
void _registerUseCases() {
  getIt.registerSingleton<LoginUseCase>(
    LoginUseCase(getIt<AuthRepository>()),
  );

  getIt.registerSingleton<RegisterUseCase>(
    RegisterUseCase(getIt<AuthRepository>()),
  );

  getIt.registerSingleton<CreateEventUseCase>(
    CreateEventUseCase(getIt<EventRepository>()),
  );

  getIt.registerSingleton<GetEventsUseCase>(
    GetEventsUseCase(getIt<EventRepository>()),
  );
}

/// Register BLoCs and Cubits
void _registerBLoCs() {
  getIt.registerSingleton<AuthBloc>(
    AuthBloc(
      loginUseCase: getIt<LoginUseCase>(),
      registerUseCase: getIt<RegisterUseCase>(),
    ),
  );

  getIt.registerSingleton<EventsBloc>(
    EventsBloc(
      createEventUseCase: getIt<CreateEventUseCase>(),
      getEventsUseCase: getIt<GetEventsUseCase>(),
    ),
  );

  getIt.registerSingleton<ProfileBloc>(
    ProfileBloc(
      authRepository: getIt<AuthRepository>(),
    ),
  );
}
