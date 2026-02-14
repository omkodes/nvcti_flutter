import '../entities/project.dart';

abstract class ProjectsRepository {
  Future<List<Project>> getProjects();
}