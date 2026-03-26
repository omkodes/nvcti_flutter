import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nvcti/bloc/bloc/auth_bloc.dart';
import 'package:nvcti/bloc/bloc/booking_bloc.dart';
import 'package:nvcti/core/di/injection_container.dart';
import 'package:nvcti/core/navigation/app_router.dart';
import 'package:nvcti/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFirebaseMessaging();

  await Injector.setup();
  runApp(const MyApp());
}

Future<void> setupFirebaseMessaging() async {
  final messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    debugPrint("FCM: Notification permission granted!");
    await messaging.subscribeToTopic("global_notifications");
    debugPrint("FCM: Successfully subscribed to global_notifications!");
  } else {
    debugPrint("FCM: Notification permission denied!");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => Injector.get<AuthBloc>()),
        BlocProvider<BookingBloc>(create: (_) => Injector.get<BookingBloc>()),
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
        ),
      ),
    );
  }
}
