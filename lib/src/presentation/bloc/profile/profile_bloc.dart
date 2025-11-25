import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository authRepository;

  ProfileBloc({required this.authRepository}) : super(ProfileInitial()) {
    on<GetCurrentUserEvent>(_onGetCurrentUser);
  }

  Future<void> _onGetCurrentUser(
    GetCurrentUserEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final user = await authRepository.getCurrentUser();
      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileFailure('User not found'));
      }
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }
}
