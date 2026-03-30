import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nvcti/domain/repositories/user_repository.dart';
import '../../core/di/injection_container.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text("Not Logged In")));
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => context.canPop() ? context.pop() : context.go('/'),
        ),
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder<Map<String, dynamic>>(
        future: Injector.get<UserRepository>().getCurrentUserData(user.uid),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error loading profile: ${snapshot.error}"));
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
                            color: Colors.white,
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: CircleAvatar(
                            radius: 56,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: profilePicUrl != null && profilePicUrl.isNotEmpty
                                ? NetworkImage(profilePicUrl)
                                : const AssetImage('assets/logos/iv_profile_img.png') as ImageProvider,
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
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          _buildInfoRow('Name:', userName),
                          const Divider(height: 24, thickness: 1, color: Color(0xFFCCCCCC)),
                          _buildInfoRow('Email:', userEmail),
                          const Divider(height: 24, thickness: 1, color: Color(0xFFCCCCCC)),
                          _buildInfoRow('Admission No:', userAdmNo),
                          const Divider(height: 24, thickness: 1, color: Color(0xFFCCCCCC)),
                          _buildInfoRow('Phone:', userContact),
                          const Divider(height: 24, thickness: 1, color: Color(0xFFCCCCCC)),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                      },
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
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
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}