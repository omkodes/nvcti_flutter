import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_projects.dart';
import '../states/projects_state.dart';
import '../events/projects_event.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  final GetProjects getProjects;

  ProjectsBloc({required this.getProjects}) : super(ProjectsInitial()) {

    on<FetchProjectsEvent>((event, emit) async {
      emit(ProjectsLoading());
      try {
        final result = await getProjects();
        emit(ProjectsLoaded(allProjects: result, filteredProjects: result));
      } catch (e) {
        emit(ProjectsError(e.toString()));
      }
    });

    on<SearchProjectsEvent>((event, emit) {
      if (state is ProjectsLoaded) {
        final currentState = state as ProjectsLoaded;
        final query = event.query.toLowerCase();

        if (query.isEmpty) {
          emit(ProjectsLoaded(
            allProjects: currentState.allProjects,
            filteredProjects: currentState.allProjects,
          ));
        } else {
          final filtered = currentState.allProjects.where((project) {
            return project.title.toLowerCase().contains(query);
          }).toList();

          emit(ProjectsLoaded(
            allProjects: currentState.allProjects,
            filteredProjects: filtered,
          ));
        }
      }
    });
  }
}