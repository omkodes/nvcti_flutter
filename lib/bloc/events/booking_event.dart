abstract class BookingEvent {}

class FetchBookingsEvent extends BookingEvent {}

class SubmitBookingEvent extends BookingEvent {
  final String resourceType;
  final String equipmentName;
  final String fromDate;
  final String toDate;
  final String fromTime;
  final String toTime;

  SubmitBookingEvent({
    required this.resourceType,
    required this.equipmentName,
    required this.fromDate,
    required this.toDate,
    required this.fromTime,
    required this.toTime,
  });
}
