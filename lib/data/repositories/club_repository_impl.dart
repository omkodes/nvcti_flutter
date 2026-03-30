import 'package:nvcti/data/datasources/remote_datasource/club_remote_data_source.dart';
import 'package:nvcti/data/models/club_model.dart';
import 'package:nvcti/domain/repositories/club_repository.dart';

class ClubRepositoryImpl implements ClubRepository {
  final ClubRemoteDataSource remoteDataSource;

  ClubRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ClubModel>> getTechClubs() async {
    return await remoteDataSource.fetchClubs();
  }

  // @override
  // Future<List<Club>> getTechClubs() async {
  //   // Fetch models from data source and return as entities
  //   return await remoteDataSource.fetchClubs();
  // }
}
