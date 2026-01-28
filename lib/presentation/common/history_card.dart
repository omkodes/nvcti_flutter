import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add intl package to pubspec.yaml for date formatting

import '../../domain/entities/booking.dart';

class HistoryCard extends StatelessWidget {
  final Booking booking;

  const HistoryCard({Key? key, required this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // formatters
    final dateFormat = DateFormat('dd-MMM-yyyy');
    final timeFormat = DateFormat('hh:mm a');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- HEADER ROW ---
            Row(
              children: [
                // Icon Box
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50, // Light blue bg for icon
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.layers, // Closest match to the "stack" icon
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),

                // Title
                Expanded(
                  child: Text(
                    booking.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),

                // Status Chip
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: booking.statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    booking.statusText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(
              height: 1,
              color: Color(0xFFEEEEEE),
            ), // Thin separator
            const SizedBox(height: 12),

            // --- TIMELINE ROW ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // FROM COLUMN
                _buildDateColumn(
                  label: "From",
                  date: dateFormat.format(booking.fromDate),
                  time: timeFormat.format(booking.fromDate),
                  crossAlign: CrossAxisAlignment.start,
                ),

                // ARROW
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey,
                ),

                // TO COLUMN
                _buildDateColumn(
                  label: "To",
                  date: dateFormat.format(booking.toDate),
                  time: timeFormat.format(booking.toDate),
                  crossAlign: CrossAxisAlignment.end,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateColumn({
    required String label,
    required String date,
    required String time,
    required CrossAxisAlignment crossAlign,
  }) {
    return Column(
      crossAxisAlignment: crossAlign,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(
          date,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(time, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }
}
