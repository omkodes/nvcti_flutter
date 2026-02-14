import '../entities/project.dart';
import '../repositories/projects_repository.dart';

class GetProjects {
  final ProjectsRepository repository;

  GetProjects(this.repository);

  Future<List<Project>> call() async {
    return await repository.getProjects();
  }
}