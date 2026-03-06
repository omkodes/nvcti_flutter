import 'package:nvcti/domain/entities/club.dart';
import 'package:nvcti/domain/repositories/club_repository.dart';

class GetClubs {
  final ClubRepository repository;

  GetClubs(this.repository);

  Future<List<Club>> call() async {
    return await repository.getTechClubs();
  }
}
