abstract class AuthRepository {
  Future<void> login({required String email, required String password});

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String mobileNumber,
  });

  // --- NEW: Add the forgot password contract ---
  Future<void> sendPasswordResetEmail({required String email});
}
