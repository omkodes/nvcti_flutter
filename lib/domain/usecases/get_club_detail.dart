// lib/domain/usecases/get_club_detail.dart

import 'package:nvcti/domain/entities/club_detail.dart';
import 'package:nvcti/domain/repositories/club_detail_repository.dart';

class GetClubDetail {
  final ClubDetailRepository repository;

  GetClubDetail(this.repository);

  Future<ClubDetail> call(String clubId) async {
    return await repository.getClubDetail(clubId);
  }
}
