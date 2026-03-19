import 'package:flutter/material.dart';
import '../../domain/entities/booking_history.dart';

class BookingHistoryItem extends StatelessWidget {
  final BookingHistory item;

  const BookingHistoryItem({super.key, required this.item});

  Color _getStatusColor() {
    switch (item.status.toLowerCase()) {
      case 'yes':
      case 'booked':
        return Colors.green;
      case 'no':
      case 'cancelled':
        return Colors.red;
      case 'pending':
      default:
        return Colors.blueAccent;
    }
  }

  String _getStatusText() {
    switch (item.status.toLowerCase()) {
      case 'yes':
      case 'booked':
        return 'Booked';
      case 'no':
      case 'cancelled':
        return 'Cancelled';
      case 'pending':
      default:
        return 'Pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top Row
            Row(
              children: [
                Icon(Icons.category, color: const Color(0xFF2B5FA6), size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.resourceType,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusText(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const Divider(color: Color(0xFFE0E0E0), height: 24, thickness: 1),

            // Bottom Row (From -> To)
            Row(
              children: [
                // FROM
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("From", style: TextStyle(color: Color(0xFF757575), fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(item.resourceFromDate, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 2),
                      Text(item.resourceFromTime, style: const TextStyle(color: Color(0xFF424242), fontSize: 13)),
                    ],
                  ),
                ),

                // Arrow
                const Icon(Icons.arrow_right_alt, color: Color(0xFF9E9E9E)),

                // TO
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text("To", style: TextStyle(color: Color(0xFF757575), fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(item.resourceToDate, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 2),
                      Text(item.resourceToTime, style: const TextStyle(color: Color(0xFF424242), fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}