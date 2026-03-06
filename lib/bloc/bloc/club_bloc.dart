import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nvcti/bloc/events/club_event.dart';
import 'package:nvcti/bloc/states/club_state.dart';
import 'package:nvcti/domain/repositories/club_repository.dart';

class ClubBloc extends Bloc<ClubEvent, ClubState> {
  final ClubRepository repository;

  ClubBloc({required this.repository}) : super(ClubInitial()) {
    on<LoadClubsEvent>((event, emit) async {
      emit(ClubLoading());
      try {
        final clubs = await repository.getTechClubs();
        emit(ClubLoaded(clubs));
      } catch (e) {
        emit(ClubError(e.toString()));
      }
    });
  }
}
