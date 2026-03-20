import 'package:nvcti/domain/repositories/auth_repository.dart';

class ResendVerificationEmailUseCase {
  final AuthRepository repository;

  ResendVerificationEmailUseCase(this.repository);

  Future<void> call(String email, String password) {
    return repository.resendVerificationEmail(email: email, password: password);
  }
}
