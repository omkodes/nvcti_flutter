import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/project.dart';

class ProjectModel extends Project {
  const ProjectModel({
    required super.title,
    required super.description,
    required super.imgUrl,
    required super.club,
  });

  factory ProjectModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    return ProjectModel(
      title: data?['projectTitle'] ?? '',
      description: data?['projectDescription'] ?? '',
      imgUrl: data?['projectImgUrl'] ?? '',
      club: data?['projectClub'] ?? '',
    );
  }
}