import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nvcti/bloc/bloc/auth_bloc.dart';
import 'package:nvcti/bloc/events/auth_event.dart';
import 'package:nvcti/bloc/states/auth_state.dart';
import 'package:nvcti/domain/repositories/user_repository.dart';
import 'package:nvcti/presentation/common/loading_card.dart';
import 'package:nvcti/presentation/common/theme.dart';

import '../../core/di/injection_container.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text("Not Logged In")));
    }

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoggedOut) {
          context.go('/login');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.primaryBlue,
          title: const Text(
            'Profile',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.white,
            ),
            onPressed: () => context.canPop() ? context.pop() : context.go('/'),
          ),
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: Injector.get<UserRepository>().getCurrentUserData(user.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: LoadingCard());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text("Error loading profile: ${snapshot.error}"),
              );
            }

            final userData = snapshot.data ?? {};
            final userName = userData['userName'] ?? user.displayName ?? "N/A";
            final userEmail = userData['userEmail'] ?? user.email ?? "N/A";
            final userContact = userData['userContact'] ?? "N/A";
            final userAdmNo = userData['userAdmNo']?.toString() ?? "N/A";
            final profilePicUrl = userData['userProfilePicUrl'];

            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 230,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 170,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/logos/iv_iitism.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 110,
                          left: 20,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).cardColor,
                              border: Border.all(
                                color: Theme.of(context).cardColor,
                                width: 4,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 56,
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage:
                                  profilePicUrl != null &&
                                      profilePicUrl.isNotEmpty
                                  ? NetworkImage(profilePicUrl)
                                  : const AssetImage(
                                          'assets/logos/iv_profile_img.png',
                                        )
                                        as ImageProvider,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            _buildInfoRow('Name:', userName),
                            const Divider(height: 24, thickness: 1),
                            _buildInfoRow('Email:', userEmail),
                            const Divider(height: 24, thickness: 1),
                            _buildInfoRow('Admission No:', userAdmNo),
                            const Divider(height: 24, thickness: 1),
                            _buildInfoRow('Phone:', userContact),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  //   child: Card(
                  //     color: Theme.of(context).cardColor,
                  //     elevation: 3,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     child: BlocBuilder<ThemeCubit, ThemeMode>(
                  //       builder: (context, themeMode) {
                  //         final isDark = themeMode == ThemeMode.dark;
                  //
                  //         return SwitchListTile(
                  //           activeColor: AppTheme.primaryBlue,
                  //           title: const Text(
                  //             "Dark Mode",
                  //             style: TextStyle(fontWeight: FontWeight.bold),
                  //           ),
                  //           value: isDark,
                  //           onChanged: (value) {
                  //             context.read<ThemeCubit>().toggleTheme(value);
                  //           },
                  //           secondary: Icon(
                  //             isDark ? Icons.dark_mode : Icons.light_mode,
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),
                  //
                  // const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () => _showLogoutDialog(context),
                        icon: const Icon(Icons.logout, color: Colors.white),
                        label: const Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).brightness == Brightness.dark
                              ? Colors.red.shade900
                              : Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final labelColor = isDark ? Colors.grey[400]! : const Color(0xFF757575);
        final valueColor = isDark ? Colors.white : const Color(0xFF212121);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 14, color: labelColor)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthBloc>().add(LogoutRequested());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? Colors.red.shade900 : Colors.black,
            ),
            child: const Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
