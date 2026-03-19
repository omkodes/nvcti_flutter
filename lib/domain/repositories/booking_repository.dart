import '../entities/booking_history.dart';
import '../entities/booking_request.dart';

abstract class BookingRepository {
  Future<List<BookingHistory>> getBookings();
  Future<String> addBooking(BookingRequest request);
}