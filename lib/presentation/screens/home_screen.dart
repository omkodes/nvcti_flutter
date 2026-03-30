import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nvcti/domain/entities/menu_item.dart';
import 'package:nvcti/presentation/common/menu_grid_card.dart';
import 'package:nvcti/presentation/common/theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<MenuItem> menuItems = const [
    MenuItem(
      title: 'Clubs',
      imagePath: 'assets/logos/iv_clubs.png',
      route: '/clubs',
    ),
    MenuItem(
      title: 'Inventory',
      imagePath: 'assets/logos/iv_inventory.png',
      route: '/inventory',
    ),
    MenuItem(
      title: 'Resources',
      imagePath: 'assets/logos/iv_resources.png',
      route: '/resources',
    ),
    MenuItem(
      title: 'Forms',
      imagePath: 'assets/logos/iv_forms.png',
      route: '/forms',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              context.pushNamed('notifications');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Just push to /profile. GoRouter will intercept and route to /login if needed.
              context.push('/profile');
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            // Header with primaryBlue background
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: AppTheme.primaryBlue),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/logos/iv_nvcti_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              accountName: const Text(
                "NVCTI",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              accountEmail: const Text("Tinkering & Innovation Center"),
            ),

            // Scrollable Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    context,
                    Icons.group_outlined,
                    'Tech Clubs',
                    '/clubs',
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.work_outline,
                    'Projects',
                    '/projects',
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.emoji_events_outlined,
                    'Achievements',
                    '/achievements',
                  ),
                  const Divider(height: 32),
                  _buildDrawerItem(
                    context,
                    Icons.info_outline,
                    'About Us',
                    '/aboutUs',
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.developer_mode_outlined,
                    'Developer Contact',
                    '/developer',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'Naresh\nVashisht Centre For\nTinkering & Innovation',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                height: 1.2,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logos/iv_ism_logo.png', height: 80),
                Container(
                  height: 60,
                  width: 1,
                  color: Colors.grey,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                ),
                Image.asset('assets/logos/iv_nvcti_logo.png', height: 80),
              ],
            ),

            const SizedBox(height: 40),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
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

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    String route,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryBlue),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      onTap: () {
        Navigator.pop(context); // Close drawer
        context.go(route);
      },
    );
  }
}
