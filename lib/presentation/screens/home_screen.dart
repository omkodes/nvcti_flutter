import 'package:flutter/material.dart';
import 'package:nvcti/domain/entities/menu_item.dart';
import 'package:nvcti/presentation/common/menu_grid_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Mock data - In a real app, this would come from a Repository via a BLoC/Provider
  final List<MenuItem> menuItems = const [
    MenuItem(
      title: 'Clubs',
      imagePath: 'assets/images/clubs.png',
      route: '/clubs',
    ),
    MenuItem(
      title: 'Inventory',
      imagePath: 'assets/images/inventory.png',
      route: '/inventory',
    ),
    MenuItem(
      title: 'Resources',
      imagePath: 'assets/images/resources.png',
      route: '/resources',
    ),
    MenuItem(
      title: 'Forms',
      imagePath: 'assets/images/forms.png',
      route: '/forms',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {}, // Open Drawer
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
          IconButton(icon: const Icon(Icons.person), onPressed: () {}),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Header Text
            Text(
              'Naresh\nVashisht Centre For\nTinkering & Innovation',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                height: 1.2, // Adjust line height for the "stacked" look
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 30),

            // Logos Row
            // NOTE: Replace standard Icons with your specific Image.asset() logos
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logos/iitism_logo.png', height: 80),
                Container(
                  height: 60,
                  width: 1,
                  color: Colors.grey,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                ),
                Image.asset('assets/logos/nvcti_logo.png', height: 80),
              ],
            ),

            const SizedBox(height: 40),

            // Grid Section
            GridView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // Disable internal scrolling
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio:
                    0.85, // Adjusts the height/width ratio of cards
              ),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                return MenuGridCard(item: menuItems[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}
