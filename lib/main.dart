import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nvcti/bloc/bloc/auth_bloc.dart';
import 'package:nvcti/bloc/bloc/booking_bloc.dart';
import 'package:nvcti/bloc/bloc/notificaiton_bloc.dart';
import 'package:nvcti/core/di/injection_container.dart';
import 'package:nvcti/core/navigation/app_router.dart';
import 'package:nvcti/firebase_options.dart';
import 'package:nvcti/presentation/common/theme.dart';

import 'core/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        BlocProvider<BookingBloc>(create: (_) => Injector.get<BookingBloc>()),
        BlocProvider<NotificationBloc>(
          create: (_) => Injector.get<NotificationBloc>(),
        ),
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
          );
        },
      ),
    );
  }
}