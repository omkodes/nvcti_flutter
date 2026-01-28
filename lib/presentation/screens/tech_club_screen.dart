import 'package:flutter/material.dart';
import 'package:nvcti/domain/entities/club.dart';
import 'package:nvcti/presentation/common/club_list_card.dart';

class TechClubsScreen extends StatefulWidget {
  const TechClubsScreen({super.key});

  @override
  State<TechClubsScreen> createState() => _TechClubsScreenState();
}

class _TechClubsScreenState extends State<TechClubsScreen> {
  // In a clean architecture with BLoC/Provider, this state would be handled
  // by the State Management layer. For this UI demo, we fetch locally.
  // final ClubRepositoryImpl _repository = ClubRepositoryImpl();
  List<Club> _clubs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadClubs();
  }

  Future<void> _loadClubs() async {
    // final clubs = await _repository.getTechClubs();
    // if (mounted) {
    //   setState(() {
    //     _clubs = clubs;
    //     _isLoading = false;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.grey[100], // Light grey background from screenshot
      appBar: AppBar(
        title: const Text('Tech Clubs'),
        centerTitle: true,
        // The default back button will appear automatically
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _clubs.length,
              itemBuilder: (context, index) {
                return ClubListCard(
                  club: _clubs[index],
                  onTap: () {
                    // Navigate to Club Details
                    // Navigator.pushNamed(context, '/club_details', arguments: _clubs[index]);
                  },
                );
              },
            ),
    );
  }
}
