import '../entities/achievement.dart';
import '../repositories/achievements_repository.dart';

class GetAchievements {
  final AchievementsRepository repository;

  GetAchievements(this.repository);

  Future<List<Achievement>> call() async {
    return await repository.getAchievements();
  }
}