import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nvcti/bloc/bloc/notificaiton_bloc.dart';
import 'package:nvcti/bloc/events/notificaiton_event.dart';
import 'package:nvcti/bloc/states/notificaiton_state.dart';
import 'package:nvcti/presentation/common/loading_card.dart';
import 'package:nvcti/presentation/common/theme.dart';

import '../common/notification_item.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => context.pop(),
        ),
        elevation: 0,
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationInitial) {
            context.read<NotificationBloc>().add(LoadNotificationsEvent());
            return const Center(child: LoadingCard());
          } else if (state is NotificationLoading) {
            return const Center(child: LoadingCard());
          } else if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return const Center(child: Text("No notifications yet."));
            }
            return ListView.builder(
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                return NotificationItemWidget(
                  notification: state.notifications[index],
                );
              },
            );
          } else if (state is NotificationError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
