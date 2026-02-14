import '../../domain/entities/project.dart';

abstract class ProjectsState {}

class ProjectsInitial extends ProjectsState {}

class ProjectsLoading extends ProjectsState {}

class ProjectsLoaded extends ProjectsState {
  final List<Project> allProjects;
  final List<Project> filteredProjects;

  ProjectsLoaded({required this.allProjects, required this.filteredProjects});
}

class ProjectsError extends ProjectsState {
  final String message;
  ProjectsError(this.message);
}