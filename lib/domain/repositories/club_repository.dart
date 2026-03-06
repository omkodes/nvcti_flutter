import 'package:nvcti/domain/entities/club.dart';

abstract class ClubRepository {
  Future<List<Club>> getTechClubs();
}
