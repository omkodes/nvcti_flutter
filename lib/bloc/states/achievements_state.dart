import '../../domain/entities/achievement.dart';

abstract class AchievementsState {}

class AchievementsInitial extends AchievementsState {}

class AchievementsLoading extends AchievementsState {}

class AchievementsLoaded extends AchievementsState {
  final List<Achievement> achievements;
  AchievementsLoaded(this.achievements);
}

class AchievementsError extends AchievementsState {
  final String message;
  AchievementsError(this.message);
}