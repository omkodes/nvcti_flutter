import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_achievements.dart';
import '../events/achievements_event.dart';
import '../states/achievements_state.dart';

class AchievementsBloc extends Bloc<AchievementsEvent, AchievementsState> {
  final GetAchievements getAchievements;

  AchievementsBloc({required this.getAchievements}) : super(AchievementsInitial()) {
    on<FetchAchievementsEvent>((event, emit) async {
      emit(AchievementsLoading());
      try {
        final result = await getAchievements();
        emit(AchievementsLoaded(result));
      } catch (e) {
        emit(AchievementsError(e.toString()));
      }
    });
  }
}