import 'package:flutter/material.dart';
import 'package:nvcti/domain/entities/inventory_item.dart';

class InventoryCard extends StatelessWidget {
  final InventoryItem item;

  const InventoryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Name and Qty Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _buildQtyBadge(item.quantity),
            ],
          ),

          const SizedBox(height: 8),

          // Description
          Text(
            item.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4, // Improves readability of multi-line text
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyBadge(int qty) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF76FF03), // Bright lime green from screenshot
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "Qty: $qty",
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
