import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nvcti/bloc/bloc/inventory_bloc.dart';
import 'package:nvcti/bloc/events/inventory_event.dart';
import 'package:nvcti/bloc/states/inventory_state.dart';
import 'package:nvcti/presentation/common/inventory_card.dart';
import 'package:nvcti/presentation/common/loading_card.dart';

import '../../core/di/injection_container.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          Injector.get<InventoryBloc>()..add(LoadInventoryEvent()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Inventory"),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () => context.canPop() ? context.pop() : context.go('/'),
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
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: "Search Inventory...",
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),

            // --- LIST VIEW WITH BLOCCONSUMER ---
            Expanded(
              child: BlocConsumer<InventoryBloc, InventoryState>(
                // 1. LISTENER: Use this for side effects (popups, navigation)
                listener: (context, state) {
                  if (state is InventoryError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                // 2. BUILDER: Use this to rebuild the UI
                builder: (context, state) {
                  if (state is InventoryLoading) {
                    return const Center(child: LoadingCard());
                  }

                  if (state is InventoryLoaded) {
                    final filteredItems = state.items.where((item) {
                      final query = _searchController.text.toLowerCase();
                      return item.name.toLowerCase().contains(query);
                    }).toList();

                    if (filteredItems.isEmpty) {
                      return const Center(
                        child: Text("No items match your search."),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) =>
                          InventoryCard(item: filteredItems[index]),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
