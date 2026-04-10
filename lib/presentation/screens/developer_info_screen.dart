import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperInfoScreen extends StatelessWidget {
  const DeveloperInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Contact'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => context.canPop() ? context.pop() : context.go('/'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Meet the Team",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "The minds behind the NVCTI application.",
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[400]
                    : Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            const _DeveloperCard(
              name: 'Siddharth Gorai',
              role: 'Team Lead',
              department: 'Petroleum Engineering',
              batch: 'Batch of 2026',
              imagePath: 'assets/logos/iv_siddharth.jpeg',
              phone: '+91 8789185248',
              email: 'goraisiddharth@gmail.com',
            ),

            const SizedBox(height: 16),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Developers",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 8),

            const _DeveloperCard(
              name: 'Yashendra Awasthi',
              role: 'Developer',
              department: 'Integrated Applied Geology',
              batch: 'Batch of 2029',
              imagePath: 'assets/logos/iv_yashendra.jpeg',
              phone: '+91 9236311195',
              email: 'yashendraawasthi@gmail.com',
            ),

            const _DeveloperCard(
              name: 'Omkar Sanap',
              role: 'Developer',
              department: 'Environmental Engineering',
              batch: 'Batch of 2028',
              imagePath: 'assets/logos/iv_omkar.jpeg',
              phone: '+91 8551095999',
              email: '24je0226@iitism.ac.in',
            ),
          ],
        ),
      ),
    );
  }
}

class _DeveloperCard extends StatelessWidget {
  final String name;
  final String role;
  final String department;
  final String batch;
  final String imagePath;
  final String phone;
  final String email;

  const _DeveloperCard({
    required this.name,
    required this.role,
    required this.department,
    required this.batch,
    required this.imagePath,
    required this.phone,
    required this.email,
  });

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      debugPrint('Could not launch $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(imagePath),
              backgroundColor: Colors.grey.shade200,
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              role,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '$department\n$batch | IIT(ISM) Dhanbad',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),

            InkWell(
              onTap: () => _launchUrl('tel:$phone'),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.phone, size: 18, color: Colors.blueGrey),
                    const SizedBox(width: 8),
                    Text(
                      phone,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            InkWell(
              onTap: () => _launchUrl('mailto:$email'),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.email, size: 18, color: Colors.blueGrey),
                    const SizedBox(width: 8),
                    Text(
                      email,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
