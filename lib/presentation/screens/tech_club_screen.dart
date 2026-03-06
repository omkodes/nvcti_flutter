import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nvcti/bloc/bloc/club_bloc.dart';
import 'package:nvcti/bloc/events/club_event.dart';
import 'package:nvcti/bloc/states/club_state.dart';
import 'package:nvcti/core/di/injection_container.dart';

import '../common/club_list_card.dart';

class TechClubScreen extends StatelessWidget {
  const TechClubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Access the bloc instance from the Injector and trigger the load event
      create: (context) => Injector.get<ClubBloc>()..add(LoadClubsEvent()),
      child: Scaffold(
        backgroundColor: Colors.grey[100], // Light grey background
        appBar: AppBar(
          title: const Text('Tech Clubs'),
          centerTitle: true,
          // Explicitly adding the back button for GoRouter compatibility
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () {
              if (context.canPop()) {
                context.pop(); // Returns to previous screen if stack exists
              } else {
                context.go('/'); // Forced fallback to Home screen
              }
            },
          ),
        ),
        body: BlocBuilder<ClubBloc, ClubState>(
          builder: (context, state) {
            if (state is ClubLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ClubLoaded) {
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: state.clubs.length,
                itemBuilder: (context, index) {
                  return ClubListCard(club: state.clubs[index]);
                },
              );
            }

            if (state is ClubError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              );
            }

            return const Center(child: Text("No clubs found."));
          },
        ),
      ),
    );
  }
}
