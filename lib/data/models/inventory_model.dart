import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/inventory_item.dart';

class InventoryModel extends InventoryItem {
  const InventoryModel({
    required super.id,
    required super.name,
    required super.description,
    required super.quantity,
  });

  factory InventoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Mimicking the Kotlin 'when' logic for type safety
    final quantityField = data['itemQuantityAvailable'];
    String quantityString;

    if (quantityField is num) {
      // Handles both int (Long) and double
      quantityString = quantityField.toString();
    } else if (quantityField is String) {
      quantityString = quantityField;
    } else {
      quantityString = "0";
    }

    return InventoryModel(
      id: doc.id,
      name: data['itemName'] ?? '',
      description: data['itemDescription'] ?? '',
      quantity: quantityString,
    );
  }
}
