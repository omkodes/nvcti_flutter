import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/achievement.dart';

class AchievementModel extends Achievement {
  const AchievementModel({
    required super.title,
    required super.description,
    required super.imgUrl,
    required super.club,
  });

  factory AchievementModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    return AchievementModel(
      title: data?['achievementTitle'] ?? 'Untitled',
      description: data?['achievementDescription'] ?? '',
      imgUrl: data?['achievementImgUrl'] ?? '',
      club: data?['achievementClub'] ?? '',
    );
  }
}