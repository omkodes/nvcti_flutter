import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/inventory_model.dart';

abstract class InventoryRemoteDataSource {
  Future<List<InventoryModel>> fetchInventory();
}

class InventoryRemoteDataSourceImpl implements InventoryRemoteDataSource {
  final FirebaseFirestore firestore;
  InventoryRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<InventoryModel>> fetchInventory() async {
    final snapshot = await firestore.collection('inventory').get();
    return snapshot.docs
        .map((doc) => InventoryModel.fromFirestore(doc))
        .toList();
  }
}
