import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nvcti/domain/entities/menu_item.dart';

class MenuGridCard extends StatelessWidget {
  final MenuItem item;

  const MenuGridCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          context.push(item.route);
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
                child: Image.asset(item.imagePath, fit: BoxFit.contain),
              ),
            ),
            // Title Container
            Expanded(
              flex: 1,
              child: Text(
                item.title,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.grey[400] : Colors.grey,
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
