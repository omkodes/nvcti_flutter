// lib/domain/repositories/club_detail_repository.dart

import 'package:nvcti/domain/entities/club_detail.dart';

abstract class ClubDetailRepository {
  Future<ClubDetail> getClubDetail(String clubId);
}
