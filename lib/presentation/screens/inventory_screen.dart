import 'package:flutter/material.dart';
import 'package:nvcti/domain/entities/inventory_item.dart';
import 'package:nvcti/presentation/common/inventory_card.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  // Mock Data
  final List<InventoryItem> _allItems = const [
    InventoryItem(
      id: '1',
      name: 'RTC Module',
      description:
          'A Real-Time Clock (RTC) module that keeps track of the current time and date, even when the main power is off.',
      quantity: 15,
    ),
    InventoryItem(
      id: '2',
      name: 'Flex Sensor',
      description:
          'A sensor that changes its resistance as it is bent, used for measuring angles or detecting bending motion.',
      quantity: 15,
    ),
    InventoryItem(
      id: '3',
      name: 'PCB Screw Terminal Block',
      description:
          'Terminal blocks that screw onto a PCB, providing a secure and removable connection for wires.',
      quantity: 250,
    ),
    InventoryItem(
      id: '4',
      name: 'PIR Motion Detector Module',
      description:
          'A Passive Infrared (PIR) sensor module used to detect motion by sensing changes in infrared radiation.',
      quantity: 30,
    ),
  ];

  // State for filtering
  List<InventoryItem> _filteredItems = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredItems = _allItems; // Initial state shows all
  }

  void _runFilter(String keyword) {
    List<InventoryItem> results = [];
    if (keyword.isEmpty) {
      results = _allItems;
    } else {
      results = _allItems
          .where(
            (item) => item.name.toLowerCase().contains(keyword.toLowerCase()),
          )
          .toList();
    }
    setState(() {
      _filteredItems = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Inventory"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // --- SEARCH BAR ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30), // Pill shape
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _runFilter,
                decoration: const InputDecoration(
                  hintText: "Search Inventory...",
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          // --- LIST VIEW ---
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                return InventoryCard(item: _filteredItems[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
