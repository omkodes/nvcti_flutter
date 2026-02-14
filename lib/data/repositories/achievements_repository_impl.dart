import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/repositories/achievements_repository.dart';
import '../models/achievements_model.dart';

class AchievementsRepositoryImpl implements AchievementsRepository {
  final FirebaseFirestore firestore;

  AchievementsRepositoryImpl({required this.firestore});

  @override
  Future<List<Achievement>> getAchievements() async {
    try {
      final snapshot = await firestore.collection("AchievementsData").get();
      return snapshot.docs
          .map((doc) => AchievementModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }
}