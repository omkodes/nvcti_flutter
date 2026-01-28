import 'package:flutter/material.dart';

enum BookingStatus { pending, approved, rejected }

class Booking {
  final String id;
  final String title;
  final DateTime fromDate;
  final DateTime toDate;
  final BookingStatus status;

  const Booking({
    required this.id,
    required this.title,
    required this.fromDate,
    required this.toDate,
    required this.status,
  });

  // Helper to get color based on status
  Color get statusColor {
    switch (status) {
      case BookingStatus.pending:
        return const Color(0xFF1565C0); // Primary Blue
      case BookingStatus.approved:
        return Colors.green;
      case BookingStatus.rejected:
        return Colors.red;
    }
  }

  // Helper to get string representation
  String get statusText {
    return status.name[0].toUpperCase() + status.name.substring(1);
  }
}
