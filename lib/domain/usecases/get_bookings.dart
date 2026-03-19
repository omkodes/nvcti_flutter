import '../entities/booking_history.dart';
import '../repositories/booking_repository.dart';

class GetBookings {
  final BookingRepository repository;

  GetBookings(this.repository);

  Future<List<BookingHistory>> call() async {
    return await repository.getBookings();
  }
}