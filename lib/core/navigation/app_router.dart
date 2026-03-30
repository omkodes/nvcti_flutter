import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nvcti/presentation/screens/about_us_screen.dart';
import 'package:nvcti/presentation/screens/achievements_page.dart';
import 'package:nvcti/presentation/screens/booking_form_page.dart';
import 'package:nvcti/presentation/screens/developer_info_screen.dart';
import 'package:nvcti/presentation/screens/forgot_password_screen.dart';
import 'package:nvcti/presentation/screens/forms_page.dart';
import 'package:nvcti/presentation/screens/history_page.dart';
import 'package:nvcti/presentation/screens/home_screen.dart';
import 'package:nvcti/presentation/screens/inventory_screen.dart';
import 'package:nvcti/presentation/screens/login_screen.dart';
import 'package:nvcti/presentation/screens/profile_screen.dart';
import 'package:nvcti/presentation/screens/projects_page.dart';
import 'package:nvcti/presentation/screens/register_screen.dart';
import 'package:nvcti/presentation/screens/tech_club_screen.dart';


class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    // This stream listener tells the router to refresh whenever auth state changes (login/logout)
    refreshListenable: GoRouterRefreshStream(
      FirebaseAuth.instance.authStateChanges(),
    ),

    // The redirect logic acts as our navigation gatekeeper
    redirect: (BuildContext context, GoRouterState state) {
      final bool isLoggedIn = FirebaseAuth.instance.currentUser != null;
      final bool isGoingToAuthScreen =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/forgot-password';

      // Define which routes require the user to be logged in
      final bool requiresAuth =
          state.matchedLocation == '/profile' ||
          state.matchedLocation == '/resources';

      if (requiresAuth && !isLoggedIn) {
        // Redirect to login if trying to access a protected route without being logged in
        return '/login';
      }

      if (isLoggedIn && isGoingToAuthScreen) {
        // If logged in and trying to access login/register/forgot-password, send them to profile or home
        return '/profile';
      }

      return null; // No redirect needed, let them go to their destination
    },

    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/clubs',
        builder: (context, state) => const TechClubScreen(),
      ),
      GoRoute(
        path: '/inventory',
        builder: (context, state) => const InventoryScreen(),
      ),
      GoRoute(path: '/forms', builder: (context, state) => const FormsPage()),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryPage(),
      ),
      GoRoute(
        path: '/resources',
        builder: (context, state) => const ResourceBookingForm(),
      ),
      GoRoute(
        path: '/projects',
        builder: (context, state) => const ProjectsPage(),
      ),
      GoRoute(
        path: '/achievements',
        builder: (context, state) => const AchievementsPage(),
      ),
      GoRoute(
        path: '/aboutUs',
        builder: (context, state) => const AboutUsScreen(),
      ),
      GoRoute(
        path: '/developer',
        builder: (context, state) => const DeveloperInfoScreen(),
      ),
    ],
  );
}

// Helper class to convert a Stream into a Listenable for GoRouter
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }
  late final StreamSubscription<dynamic> _subscription;
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
