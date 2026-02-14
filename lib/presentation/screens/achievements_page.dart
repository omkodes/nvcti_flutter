import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../bloc/bloc/achievements_bloc.dart';
import '../../bloc/events/achievements_event.dart';
import '../../bloc/states/achievements_state.dart';
import '../../data/repositories/achievements_repository_impl.dart';
import '../../domain/usecases/get_achievements.dart';
import '../common/achievement_item.dart';
import 'loading_card.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = AchievementsRepositoryImpl(firestore: FirebaseFirestore.instance);
    final useCase = GetAchievements(repository);

    return BlocProvider(
      create: (context) => AchievementsBloc(getAchievements: useCase)
        ..add(FetchAchievementsEvent()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: const AchievementsView(),
      ),
    );
  }
}

class AchievementsView extends StatelessWidget {
  const AchievementsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AchievementsBloc, AchievementsState>(
      builder: (context, state) {
        return Stack(
          children: [
            if (state is AchievementsLoaded)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: state.achievements.length,
                  itemBuilder: (context, index) {
                    return AchievementItem(achievement: state.achievements[index]);
                  },
                ),
              ),

            if (state is AchievementsError)
              Center(child: Text("Error: ${state.message}")),

            if (state is AchievementsLoading || state is AchievementsInitial)
              const Center(child: LoadingCard()),
          ],
        );
      },
    );
  }
}