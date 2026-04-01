import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
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
              "NVCTI",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
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

            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/logos/iv_naresh_vashist.png'),
                      backgroundColor: Colors.transparent,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Shri Naresh Vashisht",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Petroleum Engineer, Batch of 1967",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Pioneering the setup of our Innovation Cell, our distinguished alumni have been instrumental in fostering a culture of innovation and entrepreneurship.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/logos/iv_director.jpg'),
                      backgroundColor: Colors.transparent,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Prof. Sukumar Mishra",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Director, IIT(ISM) Dhanbad",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Welcome to the Innovation Cell. Our goal is to foster creativity, encourage research, and support students in turning ideas into reality.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Administration Title
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Administration",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 8),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: const [
                  _AdminCard(
                    imagePath: 'assets/logos/iv_dean_sir.png',
                    name: 'Prof. Alok Kumar Das',
                    designation: 'Dean, NVCTI',
                  ),
                  _AdminCard(
                    imagePath: 'assets/logos/iv_ramesh_sir.png',
                    name: 'Mr. Ramesh Prasad',
                    designation: 'Technical Officer',
                  ),
                  _AdminCard(
                    imagePath: 'assets/logos/iv_deepak_kr_gope.png',
                    name: 'Mr. Deepak Kumar Gope',
                    designation: 'Junior Technician',
                  ),
                  _AdminCard(
                    imagePath: 'assets/logos/iv_amit_biswas.png',
                    name: 'Mr. Amit Biswas',
                    designation: 'Junior Technician',
                  ),
                  _AdminCard(
                    imagePath: 'assets/logos/iv_ripu_kumar.jpg',
                    name: 'Mr. Ripu Kumar',
                    designation: 'Junior Technician',
                  ),
                  _AdminCard(
                    imagePath: 'assets/logos/iv_vishnu_mahato.jpg',
                    name: 'Mr. Vishnu Mahato',
                    designation: 'Junior Technician',
                  ),
                  _AdminCard(
                    imagePath: 'assets/logos/iv_deepak_prasad.png',
                    name: 'Mr. Deepak Prasad Sahu',
                    designation: 'Junior Assistant',
                  ),
                  _AdminCard(
                    imagePath: 'assets/logos/iv_rohit_kr.jpg',
                    name: 'Mr. Rohit Kumar Pandey',
                    designation: 'Junior Assistant',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String designation;

  const _AdminCard({
    required this.imagePath,
    required this.name,
    required this.designation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(imagePath),
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              designation,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[400]
                    : Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
