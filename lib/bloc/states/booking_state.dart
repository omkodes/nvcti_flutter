import '../../domain/entities/booking_history.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingLoaded extends BookingState {
  final List<BookingHistory> bookings;
  BookingLoaded(this.bookings);
}

class BookingError extends BookingState {
  final String message;
  BookingError(this.message);
}

class BookingSubmitSuccess extends BookingState {
  final String message;
  BookingSubmitSuccess(this.message);
}

class BookingSubmitError extends BookingState {
  final String error;
  BookingSubmitError(this.error);
}