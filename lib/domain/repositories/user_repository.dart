abstract class UserRepository {
  Future<Map<String, dynamic>> getCurrentUserData(String uid);
}