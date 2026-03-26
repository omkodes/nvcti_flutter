import 'package:flutter/material.dart';

class OurTeamPage extends StatelessWidget {
  const OurTeamPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "NVCTI",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "Driving innovation and entrepreneurship in our institution.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              _buildLargeProfileCard(
                imagePath: 'assets/images/iv_naresh_vashist.png',
                name: "Shri Naresh Vashisht",
                subtitle: "Petroleum Engineer, Batch of 1967",
                description: "Pioneering the setup of our Innovation Cell, our distinguished alumni have been instrumental in fostering a culture of innovation and entrepreneurship.",
              ),

              _buildLargeProfileCard(
                imagePath: 'assets/images/iv_director.png',
                name: "Prof. Sukumar Mishra",
                subtitle: "Director, IIT(ISM) Dhanbad",
                description: "Welcome to the Innovation Cell. Our goal is to foster creativity, encourage research, and support students in turning ideas into reality.",
              ),

              const SizedBox(height: 16),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Administration",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildAdminCard(
                      imagePath: 'assets/images/iv_dean_sir.png',
                      name: "Prof.Alok Kumar Das",
                      role: "Dean, NVCTI",
                    ),
                    _buildAdminCard(
                      imagePath: 'assets/images/iv_ramesh_sir.png',
                      name: "Mr. Ramesh Prasad",
                      role: "Technical Officer",
                    ),
                    _buildAdminCard(
                      imagePath: 'assets/images/iv_deepak_kr_gope.png',
                      name: "Mr. Deepak Kumar Gope",
                      role: "Junior Technician",
                    ),
                    _buildAdminCard(
                      imagePath: 'assets/images/iv_amit_biswas.png',
                      name: "Mr. Amit Biswas",
                      role: "Junior Technician",
                    ),
                    _buildAdminCard(
                      imagePath: 'assets/images/iv_ripu_kumar.png',
                      name: "Mr. Ripu Kumar",
                      role: "Junior Technician",
                    ),
                    _buildAdminCard(
                      imagePath: 'assets/images/iv_vishnu_mahato.png',
                      name: "Mr. Vishnu Mahato",
                      role: "Junior Technician",
                    ),
                    _buildAdminCard(
                      imagePath: 'assets/images/iv_deepak_prasad.png',
                      name: "Mr. Deepak Prasad Sahu",
                      role: "Junior Assistant",
                    ),
                    _buildAdminCard(
                      imagePath: 'assets/images/iv_rohit_kr.png',
                      name: "Mr. Rohit Kumar Pandey",
                      role: "Junior Assistant",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets to keep code clean ---

  Widget _buildLargeProfileCard({
    required String imagePath,
    required String name,
    required String subtitle,
    required String description,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Matches CircleImageView
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[200], // Background while loading
              backgroundImage: AssetImage(imagePath),
              // Note: If using network images, use NetworkImage(url)
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                height: 1.3, // lineSpacingExtra equivalent
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard({
    required String imagePath,
    required String name,
    required String role,
  }) {
    return Card(
      margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[200],
              backgroundImage: AssetImage(imagePath),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              role,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}