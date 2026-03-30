
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/booking_request.dart';
import '../../domain/usecases/add_booking.dart';
import '../../domain/usecases/get_bookings.dart';
import '../../domain/repositories/user_repository.dart';
import '../events/booking_event.dart';
import '../states/booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final GetBookings getBookings;
  final AddBooking addBooking;
  final UserRepository userRepository;

  BookingBloc({
    required this.getBookings,
    required this.addBooking,
    required this.userRepository,
  }) : super(BookingInitial()) {

    on<FetchBookingsEvent>(_onFetchBookings);
    on<SubmitBookingEvent>(_onSubmitBooking);
  }

  Future<void> _onFetchBookings(
      FetchBookingsEvent event,
      Emitter<BookingState> emit,
      ) async {
    emit(BookingLoading());
    try {
      final bookings = await getBookings.call();
      emit(BookingLoaded(bookings));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> _onSubmitBooking(
      SubmitBookingEvent event,
      Emitter<BookingState> emit,
      ) async {
    emit(BookingLoading());
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      final userData = await userRepository.getCurrentUserData(user.uid);

      final userName = userData['userName'] ?? user.displayName ?? "Unknown User";
      final userContact = userData['userContact'] ?? "N/A";
      final String email = userData['userEmail'] ?? user.email ?? "";
      final userAdmNo = userData['userAdmNo']?.toString() ?? "00";

      final request = BookingRequest(
        userId: user.uid,
        userName: userName,
        userAdmNo: userAdmNo,
        userEmail: email,
        userContact: userContact,
        resourceType: event.resourceType,
        resourceName: event.resourceType == "Equipment" ? event.equipmentName : "",
        resourceFromDate: event.fromDate,
        resourceToDate: event.toDate,
        resourceFromTime: event.fromTime,
        resourceToTime: event.toTime,
      );

      final result = await addBooking.call(request);
      emit(BookingSubmitSuccess(result));

    } catch (e) {
      emit(BookingSubmitError(e.toString()));
    }
  }
}