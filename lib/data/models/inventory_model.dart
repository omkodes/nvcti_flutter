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
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return InventoryModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      quantity: data['quantity'] ?? 0,
    );
  }
}
