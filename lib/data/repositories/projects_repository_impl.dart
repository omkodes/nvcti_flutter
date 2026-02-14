import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/project.dart';
import '../../domain/repositories/projects_repository.dart';
import '../models/project_model.dart';

class ProjectsRepositoryImpl implements ProjectsRepository {
  final FirebaseFirestore firestore;

  ProjectsRepositoryImpl({required this.firestore});

  @override
  Future<List<Project>> getProjects() async {
    try {
      final snapshot = await firestore.collection("ProjectsData").get();
      return snapshot.docs
          .map((doc) => ProjectModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception("Error fetching projects: $e");
    }
  }
}