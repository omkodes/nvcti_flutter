import 'package:flutter/material.dart';
import 'package:nvcti/domain/entities/club.dart';

class ClubListCard extends StatelessWidget {
  final Club club;
  final VoidCallback onTap;

  const ClubListCard({super.key, required this.club, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16), // Spacing between cards
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4), // Subtle drop shadow
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16.0,
            ),
            child: Row(
              children: [
                // Logo Container
                Container(
                  width: 50,
                  height: 50,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white, // Ensure logo sits on white
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    club.logoPath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback if asset is missing during dev
                      return const Icon(Icons.group, color: Colors.grey);
                    },
                  ),
                ),
                const SizedBox(width: 16),

                // Club Name
                Expanded(
                  child: Text(
                    club.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow
                        .ellipsis, // Handles long names like "Entrepreneurship..."
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
