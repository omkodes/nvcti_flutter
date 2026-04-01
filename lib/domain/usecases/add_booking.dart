import '../entities/booking_request.dart';
import '../repositories/booking_repository.dart';

class AddBooking {
  final BookingRepository repository;

  AddBooking(this.repository);

  Future<String> call(BookingRequest request) async {
    return await repository.addBooking(request);
  }
}
