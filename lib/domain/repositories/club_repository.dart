import 'package:nvcti/data/models/club_model.dart';

abstract class ClubRepository {
  Future<List<ClubModel>> getTechClubs();
}
