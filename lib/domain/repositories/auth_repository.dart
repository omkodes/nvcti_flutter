abstract class AuthRepository {
  Future<void> login({required String email, required String password});

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String mobileNumber,
  });

  Future<void> sendPasswordResetEmail({required String email});

  // NEW: Resend verification email
  Future<void> resendVerificationEmail({
    required String email,
    required String password,
  });

  Future<void> logout();
}
