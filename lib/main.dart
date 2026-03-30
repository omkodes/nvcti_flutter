import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nvcti/bloc/bloc/auth_bloc.dart';
import 'package:nvcti/bloc/bloc/booking_bloc.dart';
import 'package:nvcti/core/di/injection_container.dart';
import 'package:nvcti/core/navigation/app_router.dart';
import 'package:nvcti/firebase_options.dart';
import 'package:nvcti/presentation/common/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Injector.setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => Injector.get<AuthBloc>()),
        // ADD THIS LINE FOR YOUR RESOURCES SCREEN:
        BlocProvider<BookingBloc>(create: (_) => Injector.get<BookingBloc>()),
        // You can also add your ClubBloc and InventoryBloc here if you are testing them!
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
      ),
    );
  }
}
