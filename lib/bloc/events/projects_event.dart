abstract class ProjectsEvent {}

class FetchProjectsEvent extends ProjectsEvent {}

class SearchProjectsEvent extends ProjectsEvent {
  final String query;
  SearchProjectsEvent(this.query);
}