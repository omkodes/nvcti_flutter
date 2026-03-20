import 'package:nvcti/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCase(this.repository);

  // Add mobileNumber here
  Future<void> call(
    String name,
    String email,
    String password,
    String mobileNumber,
  ) {
    return repository.register(
      name: name,
      email: email,
      password: password,
      mobileNumber: mobileNumber,
    );
  }
}
