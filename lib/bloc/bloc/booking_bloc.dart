import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/booking_request.dart';
import '../../domain/usecases/add_booking.dart';
import '../../domain/usecases/get_bookings.dart';
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

        // 1. Fetch Real User Data from Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        final userData = userDoc.data() ?? {};

        // 2. Map the data (with smart fallbacks)
        final userName =
            userData['userName'] ?? user.displayName ?? "Unknown User";
        final userContact = userData['userContact'] ?? "N/A";

        // Smart fallback: Extract admission number from email (e.g., 20JE0000@iitism.ac.in -> 20JE0000)
        final String email = userData['userEmail'] ?? "";
        final userAdmNo = userData['userAdmNo'] ?? 00;

        // 3. Create Request Object
        final request = BookingRequest(
          userId: user.uid,
          userName: userName,
          userAdmNo: userAdmNo,
          userEmail: email,
          userContact: userContact,
          resourceType: event.resourceType,
          resourceName: event.resourceType == "Equipment"
              ? event.equipmentName
              : "",
          resourceFromDate: event.fromDate,
          resourceToDate: event.toDate,
          resourceFromTime: event.fromTime,
          resourceToTime: event.toTime,
        );

        // 4. Submit to Google Sheets API
        final result = await addBooking(request);
        emit(BookingSubmitSuccess(result));
      } catch (e) {
        emit(BookingSubmitError(e.toString()));
      }
    });
  }
}
