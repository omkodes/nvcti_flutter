// lib/data/repositories/club_detail_repository_impl.dart

import 'package:nvcti/data/datasources/remote_datasource/club_detail_remote_data_source.dart';
import 'package:nvcti/domain/entities/club_detail.dart';
import 'package:nvcti/domain/repositories/club_detail_repository.dart';

class ClubDetailRepositoryImpl implements ClubDetailRepository {
  final ClubDetailRemoteDataSource remoteDataSource;

  ClubDetailRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ClubDetail> getClubDetail(String clubId) async {
    return await remoteDataSource.fetchClubDetail(clubId);
  }
}
