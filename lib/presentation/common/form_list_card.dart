import 'package:flutter/material.dart';
import 'package:nvcti/domain/entities/form_item.dart';

class FormListCard extends StatelessWidget {
  final FormItem formItem;
  final VoidCallback onTap;

  const FormListCard({super.key, required this.formItem, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 16.0,
            ),
            child: Row(
              children: [
                // Leading Icon (Document style)
                // Using a container to mimic the colored icon asset in the screenshot
                Image.asset(
                  formItem.iconPath,
                  width: 32,
                  height: 32,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.description_outlined,
                    size: 32,
                    color:
                        Colors.amber, // Fallback color matching screenshot vibe
                  ),
                ),

                const SizedBox(width: 16),

                // Title
                Expanded(
                  child: Text(
                    formItem.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500, // Medium weight
                      color: Colors.black87,
                    ),
                  ),
                ),

                // Trailing Icon (External Link)
                const Icon(
                  Icons.open_in_new_rounded, // Matches the box+arrow icon
                  color: Colors.black,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
