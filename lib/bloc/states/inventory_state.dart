import 'package:nvcti/domain/entities/inventory_item.dart';

abstract class InventoryState {}

class InventoryLoading extends InventoryState {}

class InventoryLoaded extends InventoryState {
  final List<InventoryItem> items;
  InventoryLoaded(this.items);
}

class InventoryError extends InventoryState {
  final String message;
  InventoryError(this.message);
}
