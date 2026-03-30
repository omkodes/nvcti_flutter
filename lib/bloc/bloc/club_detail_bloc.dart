// lib/bloc/bloc/club_detail_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nvcti/bloc/events/club_detail_event.dart';
import 'package:nvcti/bloc/states/club_detail_state.dart';
import 'package:nvcti/domain/usecases/get_club_detail.dart';

class ClubDetailBloc extends Bloc<ClubDetailEvent, ClubDetailState> {
  final GetClubDetail getClubDetail;

  ClubDetailBloc({required this.getClubDetail}) : super(ClubDetailInitial()) {
    on<LoadClubDetailEvent>((event, emit) async {
      emit(ClubDetailLoading());
      try {
        final club = await getClubDetail(event.clubId);
        emit(ClubDetailLoaded(club));
      } catch (e) {
        emit(ClubDetailError(e.toString()));
      }
    });
  }
}
