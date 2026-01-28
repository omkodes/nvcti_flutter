import 'package:flutter/material.dart';
import 'package:nvcti/domain/entities/booking.dart';
import 'package:nvcti/presentation/common/history_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data mimicking your screenshot
    // In real app, this comes from a Repository/Bloc
    final List<Booking> historyList = [
      Booking(
        id: '1',
        title: 'Ideation Room 2',
        status: BookingStatus.pending,
        fromDate: DateTime(2026, 1, 28, 19, 11), // 7:11 PM
        toDate: DateTime(2026, 1, 29, 21, 11), // 9:11 PM
      ),
      // Adding a dummy second item to show list capability
      Booking(
        id: '2',
        title: '3D Printing Lab',
        status: BookingStatus.approved,
        fromDate: DateTime(2026, 1, 25, 10, 00),
        toDate: DateTime(2026, 1, 25, 12, 00),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light grey background
      appBar: AppBar(
        title: const Text("History"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: historyList.length,
        itemBuilder: (context, index) {
          return HistoryCard(booking: historyList[index]);
        },
      ),
    );
  }
}
