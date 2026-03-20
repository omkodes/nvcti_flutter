import 'package:equatable/equatable.dart';

class InventoryItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final String quantity;

  const InventoryItem({
    required this.id,
    required this.name,
    required this.description,
    required this.quantity,
  });
  @override
  List<Object?> get props => [id, name, description, quantity];
}
