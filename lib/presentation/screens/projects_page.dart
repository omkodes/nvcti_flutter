import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../bloc/bloc/projects_bloc.dart';
import '../../bloc/events/projects_event.dart';
import '../../bloc/states/projects_state.dart';
import '../../data/repositories/projects_repository_impl.dart';
import '../../domain/usecases/get_projects.dart';
import '../common/project_item.dart';
import 'loading_card.dart';


class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = ProjectsRepositoryImpl(firestore: FirebaseFirestore.instance);
    final useCase = GetProjects(repository);

    return BlocProvider(
      create: (context) => ProjectsBloc(getProjects: useCase)..add(FetchProjectsEvent()),
      child: Scaffold(
        backgroundColor: Colors.white, // @color/white
        body: const ProjectsView(),
      ),
    );
  }
}

class ProjectsView extends StatelessWidget {
  const ProjectsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Search Projects...",
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    onChanged: (value) {
                      context.read<ProjectsBloc>().add(SearchProjectsEvent(value));
                    },
                  ),
                ),
              ),

              Expanded(
                child: BlocBuilder<ProjectsBloc, ProjectsState>(
                  builder: (context, state) {
                    if (state is ProjectsLoaded) {
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: state.filteredProjects.length,
                        itemBuilder: (context, index) {
                          return ProjectItem(project: state.filteredProjects[index]);
                        },
                      );
                    }
                    if (state is ProjectsError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),

          BlocBuilder<ProjectsBloc, ProjectsState>(
            builder: (context, state) {
              if (state is ProjectsLoading || state is ProjectsInitial) {
                return const Center(child: LoadingCard());
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}