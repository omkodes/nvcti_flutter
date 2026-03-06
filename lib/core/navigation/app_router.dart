import 'package:go_router/go_router.dart';
import 'package:nvcti/presentation/screens/forms_screen.dart';
import 'package:nvcti/presentation/screens/history_screen.dart';
import 'package:nvcti/presentation/screens/home_screen.dart';
import 'package:nvcti/presentation/screens/inventory_screen.dart';
import 'package:nvcti/presentation/screens/login_screen.dart';
import 'package:nvcti/presentation/screens/register_screen.dart';
import 'package:nvcti/presentation/screens/tech_club_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return HomeScreen();
        },
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/clubs',
        builder: (context, state) => const TechClubScreen(),
      ),
      GoRoute(
        path: '/inventory',
        builder: (context, state) => const InventoryScreen(),
      ),
      GoRoute(path: '/forms', builder: (context, state) => const FormsScreen()),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
      ),
      // GoRoute(
      //   path: '/resources',
      //   builder: (context, state) => const ResourceScreen(),
      // ),
    ],
  );
}
