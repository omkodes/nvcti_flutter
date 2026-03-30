// lib/bloc/events/club_detail_event.dart

abstract class ClubDetailEvent {}

class LoadClubDetailEvent extends ClubDetailEvent {
  final String clubId;
  LoadClubDetailEvent(this.clubId);
}
