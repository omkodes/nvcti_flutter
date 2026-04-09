import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nvcti/core/theme_cubit.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
              context.push('/profile');
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      drawer: Drawer(
        child: Column(
          children: [
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
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "APPEARANCE",
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 1.2,

                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : const Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<ThemeCubit, ThemeMode>(
                    builder: (context, currentMode) {
                      return Row(
                        children: [
                          _buildThemeOptionButton(
                            context,
                            "System",
                            Icons.brightness_auto,
                            ThemeMode.system,
                            currentMode,
                          ),
                          _buildThemeOptionButton(
                            context,
                            "Light",
                            Icons.light_mode,
                            ThemeMode.light,
                            currentMode,
                          ),
                          _buildThemeOptionButton(
                            context,
                            "Dark",
                            Icons.dark_mode,
                            ThemeMode.dark,
                            currentMode,
                          ),
                        ],
                      );
                    },
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryBlue),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : const Color(0xFF212121),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        context.push(route);
      },
    );
  }
}

Widget _buildThemeOptionButton(
  BuildContext context,
  String label,
  IconData icon,
  ThemeMode mode,
  ThemeMode currentMode,
) {
  final isSelected = mode == currentMode;
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Expanded(
    child: GestureDetector(
      onTap: () => context.read<ThemeCubit>().updateTheme(mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryBlue
              : (isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryBlue
                : (isDark ? Colors.white24 : Colors.grey.shade300),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withOpacity(0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white60 : Colors.grey.shade600),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white60 : Colors.grey.shade600),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
