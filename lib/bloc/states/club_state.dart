import 'package:nvcti/domain/entities/club.dart';

abstract class ClubState {}

class ClubInitial extends ClubState {}

class ClubLoading extends ClubState {}

class ClubLoaded extends ClubState {
  final List<Club> clubs;
  ClubLoaded(this.clubs);
}

class ClubError extends ClubState {
  final String message;
  ClubError(this.message);
}
