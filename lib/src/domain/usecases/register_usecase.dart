import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<UserEntity> call(String email, String password, String name) {
    return repository.registerWithEmail(
      email: email,
      password: password,
      name: name,
    );
  }
}
