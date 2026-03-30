// lib/bloc/states/club_detail_state.dart

import 'package:nvcti/domain/entities/club_detail.dart';

abstract class ClubDetailState {}

class ClubDetailInitial extends ClubDetailState {}

class ClubDetailLoading extends ClubDetailState {}

class ClubDetailLoaded extends ClubDetailState {
  final ClubDetail club;
  ClubDetailLoaded(this.club);
}

class ClubDetailError extends ClubDetailState {
  final String message;
  ClubDetailError(this.message);
}
