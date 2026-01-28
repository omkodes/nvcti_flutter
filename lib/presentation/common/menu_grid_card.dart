import 'package:flutter/material.dart';
import 'package:nvcti/domain/entities/menu_item.dart';

class MenuGridCard extends StatelessWidget {
  final MenuItem item;

  const MenuGridCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: InkWell(
        onTap: () {
          // Navigator.pushNamed(context, item.route);
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image/Icon Container
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                // Using Image.asset assuming you have the illustrations
                child: Image.asset(item.imagePath, fit: BoxFit.contain),
              ),
            ),
            // Title Container
            Expanded(
              flex: 1,
              child: Text(
                item.title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey, // Grey color as per screenshot text
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
