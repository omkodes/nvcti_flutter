import 'package:nvcti/data/datasources/remote_datasource/auth_remote_data_source.dart';
import 'package:nvcti/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> login({required String email, required String password}) async {
    return await remoteDataSource.login(email, password);
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String mobileNumber,
  }) async {
    return await remoteDataSource.register(name, email, password, mobileNumber);
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    return await remoteDataSource.sendPasswordResetEmail(email);
  }

  // NEW
  @override
  Future<void> resendVerificationEmail({
    required String email,
    required String password,
  }) async {
    return await remoteDataSource.resendVerificationEmail(email, password);
  }

  Future<void> logout() async {
    return await remoteDataSource
        .logout(); // You'll need to add logout() to AuthRemoteDataSource too
  }
}
