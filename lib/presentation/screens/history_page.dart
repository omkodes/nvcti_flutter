import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../bloc/bloc/booking_bloc.dart';
import '../../bloc/events/booking_event.dart';
import '../../bloc/states/booking_state.dart';
import '../../data/repositories/booking_repository_impl.dart';
import '../../domain/usecases/add_booking.dart';
import '../../domain/usecases/get_bookings.dart';
import '../common/booking_history_item.dart';
import '../common/loading_card.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = BookingRepositoryImpl();
    final getBookingsUseCase = GetBookings(repository);
    final addBookingUseCase = AddBooking(repository);

    return BlocProvider(
      create: (context) => BookingBloc(getBookings: getBookingsUseCase,
          addBooking: addBookingUseCase)..add(FetchBookingsEvent()),
      child: const Scaffold(
        backgroundColor: Colors.white,
        body: HistoryView(),
      ),
    );
  }
}

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    // Current user filtering logic like in Kotlin
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        return Stack(
          children: [
            if (state is BookingLoaded) ...[
              Builder(builder: (context) {
                final userBookings = state.bookings
                    .where((b) => b.userId == currentUserId)
                    .toList();

                if (userBookings.isEmpty) {
                  return const Center(
                    child: Text(
                      "No History yet",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: userBookings.length,
                  itemBuilder: (context, index) {
                    return BookingHistoryItem(item: userBookings[index]);
                  },
                );
              }),
            ],

            if (state is BookingError)
              Center(child: Text(state.message)),

            if (state is BookingLoading || state is BookingInitial)
              const Center(child: LoadingCard()),
          ],
        );
      },
    );
  }
}