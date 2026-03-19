import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/usecases/get_bookings.dart';
import '../../domain/usecases/add_booking.dart';
import '../../domain/entities/booking_request.dart';
import '../events/booking_event.dart';
import '../states/booking_state.dart';
// Note: You will need to import your UserData repository/usecase here to fetch user details
// import '../../../user/domain/repositories/user_repository.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final GetBookings getBookings;
  final AddBooking addBooking;
  // final UserRepository userRepository; // Needed to fetch userName, admNo, etc.

  BookingBloc({
    required this.getBookings,
    required this.addBooking,
    // required this.userRepository,
  }) : super(BookingInitial()) {

    // ... FetchBookingsEvent logic ...

    on<SubmitBookingEvent>((event, emit) async {
      emit(BookingLoading());
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) throw Exception("User not logged in");

        // 1. Fetch User Data (Simulated based on your UserDataViewModel logic)
        // final userData = await userRepository.getUserData(user.uid);

        // Mocking user data for the example (Replace with actual fetch)
        final userName = "Fetched User"; // userData.userName
        final userAdmNo = "20JE0000";    // userData.userAdmNo
        final userContact = "999999999"; // userData.userContact

        // 2. Create Request Object
        final request = BookingRequest(
          userId: user.uid,
          userName: userName,
          userAdmNo: userAdmNo,
          userEmail: user.email ?? "",
          userContact: userContact,
          resourceType: event.resourceType,
          resourceName: event.resourceType == "Equipment" ? event.equipmentName : "",
          resourceFromDate: event.fromDate,
          resourceToDate: event.toDate,
          resourceFromTime: event.fromTime,
          resourceToTime: event.toTime,
        );

        // 3. Submit
        final result = await addBooking(request);
        emit(BookingSubmitSuccess(result));

      } catch (e) {
        emit(BookingSubmitError(e.toString()));
      }
    });
  }
}